class TeamsController < ApplicationController
  before_action :set_team, only: [ :update ]
  before_action :set_active_team, only: [ :update, :destroy, :destroy_member ]

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
    @team.cover.attach(team_params[:cover]) if team_params[:cover].present?

    if @team.update(team_params.except(:cover))
      redirect_to documents_path, notice: "Team was successfully updated."
    else
      redirect_to documents_path, inertia: { errors: @team.errors }
    end
  end

  def destroy
    authorize @team

    ActiveRecord::Base.transaction do
      @team.members.includes(:teams).find_each(batch_size: 10) do |member|
        member.set_current_team(member.teams.first)
      end
      @team.destroy!
    end

    redirect_to documents_path, notice: "Team was successfully destroyed."
  end

  def destroy_member
    ActsAsTenant.without_tenant do
      @member = @team.members.find(params.expect(:member_id))
    end

    authorize @team

    @team.remove_member(@member)

    redirect_to documents_path, notice: "Member was successfully removed."
  end


  private
    def set_team
      @team = current_user.teams.find(params[:id])
    end

    def set_active_team
      @team = current_user.active_team
    end

    def team_params
      params.expect(team: [ :name, :cover ])
    end
end
