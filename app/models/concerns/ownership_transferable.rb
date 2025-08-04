# frozen_string_literal: true

# = OwnershipTransferable
#
# This concern handles the transfer of team ownership when a user account is being deleted.
# It ensures that teams remain functional after a user leaves by either transferring
# ownership to another member or cleaning up empty teams.
#
# == Business Requirements
#
# When a user wants to destroy their account, the system must:
#
# 1. *Transfer ownership when needed:*
#    - If team has more than 1 member AND the user is the only owner
#    - Promote the first available member to owner role
#
# 2. *Delete teams when appropriate:*
#    - If team has only 1 member (the user themselves)
#    - Delete the entire team since it would be empty
#
# 3. *Do nothing when safe:*
#    - If team has other owners already
#    - Team will continue functioning normally
#
# == Examples
#
#   # Scenario 1: Solo team (1 member)
#   team.members = [current_user]
#   current_user.transfer_ownership
#   # Result: Team is deleted
#
#   # Scenario 2: Team needing ownership transfer
#   team.members = [current_user(owner), member1, member2]
#   current_user.transfer_ownership
#   # Result: member1 is promoted to owner
#
#   # Scenario 3: Team with multiple owners
#   team.members = [current_user(owner), other_owner(owner), member1]
#   current_user.transfer_ownership
#   # Result: No changes (other_owner remains)
#
# == Performance Considerations
#
# This implementation avoids N+1 queries by:
# - Bulk loading all membership data upfront
# - Using single SQL operations for updates and deletions
# - Leveraging PostgreSQL's DISTINCT ON for efficient member selection
#
module OwnershipTransferable
  extend ActiveSupport::Concern

  # Transfers ownership of teams when user account is being deleted.
  #
  # This method analyzes all teams the user belongs to and takes appropriate action:
  # - Deletes teams where user is the only member
  # - Promotes members to owners where user is the sole owner
  # - Leaves teams unchanged where other owners exist
  #
  # @return [void]
  def transfer_ownership
    ActsAsTenant.without_tenant do
      team_analysis = analyze_team_ownership
      return if team_analysis.empty?

      delete_solo_teams(team_analysis[:teams_to_delete])
      promote_members_in_teams(team_analysis[:teams_to_promote])
    end
  end

    private

      # == Step-by-Step Process Documentation
      #
      # The ownership transfer process follows these steps:
      #
      # 1. *Data Collection* (analyze_team_ownership)
      #    - Get all team IDs where user is a member
      #    - Bulk load membership statistics to avoid N+1 queries
      #    - Load user's role in each team
      #
      # 2. *Decision Making* (categorize_team)
      #    - For each team, determine the appropriate action:
      #      * :delete - Team has only this user
      #      * :promote - User is sole owner, others are members
      #      * :no_action - Team has other owners
      #
      # 3. *Execution* (delete_solo_teams & promote_members_in_teams)
      #    - Bulk delete empty teams
      #    - Bulk promote members to owners using optimized SQL

      # Analyzes all teams the user belongs to and determines what action to take.
      #
      # This method performs bulk data loading to avoid N+1 queries and categorizes
      # each team based on membership composition and user's role.
      #
      # @return [Hash] Analysis results with :teams_to_delete and :teams_to_promote arrays
      # @return [Hash] Empty hash if user belongs to no teams
      def analyze_team_ownership
        team_ids = memberships.pluck(:team_id)
        return {} if team_ids.empty?

        # Bulk load membership data to avoid N+1 queries
        membership_counts = load_membership_counts(team_ids)
        total_member_counts = load_total_member_counts(team_ids)
        user_roles = load_user_roles(team_ids)

        teams_to_delete = []
        teams_to_promote = []

        team_ids.each do |team_id|
          decision = categorize_team(team_id, membership_counts, total_member_counts, user_roles)

          case decision
          when :delete
            teams_to_delete << team_id
          when :promote
            teams_to_promote << team_id
          end
        end

        { teams_to_delete: teams_to_delete, teams_to_promote: teams_to_promote }
      end

      # Determines what action should be taken for a specific team.
      #
      # Business logic:
      # - If only 1 member (the user): Delete team
      # - If user is sole owner with other members: Promote someone
      # - If other owners exist: Do nothing
      #
      # @param team_id [Integer] The team ID to analyze
      # @param membership_counts [Hash] Counts by [team_id, role]
      # @param total_member_counts [Hash] Total members per team
      # @param user_roles [Hash] User's membership role per team
      # @return [Symbol] :delete, :promote, or :no_action
      def categorize_team(team_id, membership_counts, total_member_counts, user_roles)
        total_members = total_member_counts[team_id] || 0
        owner_count = membership_counts[[ team_id, "owner" ]] || 0
        user_is_owner = user_roles[team_id]&.role == "owner"

        return :delete if total_members == 1
        return :promote if user_is_owner && owner_count == 1 && total_members > 1

        :no_action # Team has other owners or user is not an owner
      end

      # Loads membership counts grouped by team and role in a single query.
      #
      # @param team_ids [Array<Integer>] Team IDs to analyze
      # @return [Hash] Counts keyed by [team_id, role_string] (e.g., {[1, "owner"] => 2})
      def load_membership_counts(team_ids)
        Membership.where(team_id: team_ids).group(:team_id, :role).count
      end

      # Loads total member counts per team in a single query.
      #
      # @param team_ids [Array<Integer>] Team IDs to analyze
      # @return [Hash] Total counts keyed by team_id (e.g., {1 => 3, 2 => 1})
      def load_total_member_counts(team_ids)
        Membership.where(team_id: team_ids).group(:team_id).count
      end

      # Loads the user's membership records for specified teams.
      #
      # @param team_ids [Array<Integer>] Team IDs to load
      # @return [Hash] Membership records indexed by team_id
      def load_user_roles(team_ids)
        memberships.where(team_id: team_ids).index_by(&:team_id)
      end

      # Deletes teams that only have this user as a member.
      #
      # These teams would be empty after user deletion, so they're removed entirely.
      #
      # @param team_ids [Array<Integer>] Team IDs to delete
      # @return [void]
      def delete_solo_teams(team_ids)
        Team.with_attached_cover.where(id: team_ids).destroy_all if team_ids.any?
      end

      # Promotes members to owners in teams where this user is the sole owner.
      #
      # Uses a single optimized SQL query with PostgreSQL's DISTINCT ON to:
      # 1. Find the first eligible member in each team
      # 2. Promote them to owner role in bulk
      #
      # The query selects one member per team (ordered by member_id for consistency)
      # and updates their role from member (1) to owner (0).
      #
      # @param team_ids [Array<Integer>] Team IDs needing member promotion
      # @return [void]
      def promote_members_in_teams(team_ids)
        return if team_ids.empty?

        placeholders = team_ids.map { "?" }.join(",")
        sql = ActiveRecord::Base.sanitize_sql_array([
          <<~SQL,
      UPDATE memberships
      SET role = 0
      WHERE (member_id, team_id) IN (
        SELECT DISTINCT ON (team_id) member_id, team_id
        FROM memberships
        WHERE team_id IN (#{placeholders})
          AND role = 1
          AND member_id != ?
        ORDER BY team_id, member_id
      )
      SQL
          *team_ids, id
        ])

        ActiveRecord::Base.connection.execute(sql)
      end
end
