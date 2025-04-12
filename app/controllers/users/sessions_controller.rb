class Users::SessionsController < Devise::Passwordless::SessionsController
  skip_before_action :authenticate_verified_user!

  def new
    render inertia: "Users/Sessions"
  end

  private
    def email_params
      params.fetch(:user, {}).permit(:email)[:email]
    end
end
