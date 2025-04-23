class Users::OnboardingController < Users::BaseController
  before_action :set_user
  before_action :require_unverified_user!

  def edit
    render inertia: "Users/Onboarding"
  end

  def update
    if @user.new_personal_team(user_params[:name])
      redirect_to authenticated_root_path, notice: "User updated successfully."
    else
      redirect_to user_onboarding_path, inertia: { errors: @user.errors }
    end
  end

  private
    def set_user
      @user = current_user
    end

    def user_params
      params.expect(user: [ :name ])
    end
end
