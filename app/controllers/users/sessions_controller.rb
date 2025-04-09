class Users::SessionsController < Devise::Passwordless::SessionsController
  def new
    render inertia: "Auth/SignIn"
  end

  private
    def after_magic_link_sent_path_for(resource_or_scope)
      verify_email_path(email: email_params)
    end

    def email_params
      params.fetch(:user, {}).permit(:email)[:email]
    end
end
