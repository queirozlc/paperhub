class TeamsController < ApplicationController
  # POST /teams
  def create
    @team = current_user.owned_teams.build(team_params)
    current_user.memberships.build(team: @team, role: :owner)

    if @team.save
      current_user.set_current_team(@team)
      redirect_to authenticated_root_path, notice: "Team was successfully created."
    else
      redirect_to authenticated_root_path, inertia: { errors: @team.errors }
    end
  end

  private

    def team_params
      params.expect(team: [ :name, :cover ])
    end
end
