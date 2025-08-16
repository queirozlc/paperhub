class UsersController < ApplicationController
  before_action :set_team, only: :switch_team

  # PATCH /users/:id/switch_team
  def switch_team
    authorize @team, policy_class: UserPolicy

    current_user.set_current_team(@team)
    redirect_to documents_path, notice: "Team was successfully updated."
  end

  def destroy
    User.transaction do
      current_user.transfer_ownership
      current_user.destroy
    end

    redirect_to root_path, notice: "User was successfully deleted."
  end

  private

    def set_team
      @team = current_user.teams.find_by(id: params.expect(:id))
    end
end
