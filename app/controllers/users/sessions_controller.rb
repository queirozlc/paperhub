module Users
  class SessionsController < Devise::Passwordless::SessionsController
    skip_before_action :authenticate_verified_user!, :authenticate_user!, :set_tenant

    def new
      render inertia: "Users/Sessions"
    end

  private
    def after_sign_in_path_for(resource)
      if resource.active_team_id
        documents_path
      else
        user_onboarding_path
      end
    end
  end
end
