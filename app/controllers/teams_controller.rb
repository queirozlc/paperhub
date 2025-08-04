class TeamsController < ApplicationController
  # POST /teams
  def create
    @team = current_user.owned_teams.build(team_params)
    current_user.memberships.build(team: @team, role: :owner)

    if @team.save
      current_user.set_current_team(@team)
      redirect_to documents_path, notice: "Team was successfully created."
    else
      redirect_to documents_path, inertia: { errors: @team.errors }
    end
  end

  def update
    team = current_user.teams.find(params[:id])

    team.cover.attach(team_params[:cover]) if team_params[:cover].present?

    if team.update(team_params.except(:cover))
      redirect_to documents_path, notice: "Team was successfully updated."
    else
      redirect_to documents_path, inertia: { errors: team.errors }
    end
  end

  def destroy
    team = current_user.active_team

    authorize team, :destroy?

    ActiveRecord::Base.transaction do
      team.members.includes(:owned_teams).find_each(batch_size: 10) do |member|
        member.set_current_team(member.owned_teams.first) if member.active_team == team
      end
      team.destroy!
    end

    redirect_to documents_path, notice: "Team was successfully destroyed."
  end

  def destroy_member
    team = current_user.active_team

    ActsAsTenant.without_tenant do
      @member = team.members.find(params.expect(:member_id))
    end

    authorize team, :destroy_member?

    team.remove_member(@member)

    redirect_to documents_path, notice: "Member was successfully removed."
  end


  private

    def team_params
      params.expect(team: [ :name, :cover ])
    end
end
