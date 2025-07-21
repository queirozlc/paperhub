class Users::ProfileController < ApplicationController
  before_action :set_user, only: %i[ update ]
  before_action :set_team, only: %i[ update ]

  # PATCH/PUT /users/teams/1
  def update
    @user.set_current_team(@team)
    redirect_to documents_path, notice: "Profile was successfully updated."
  end

  private

    def set_user
      @user = current_user
    end

    def set_team
      @team = current_user.teams.find(switch_team_params[:active_team_id])
    end

    def switch_team_params
      params.expect(user: [ :active_team_id ])
    end
end
