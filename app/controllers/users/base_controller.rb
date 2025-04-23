class Users::BaseController < ApplicationController
  skip_before_action :authenticate_verified_user!

  protected

    def require_unverified_user!
      redirect_to authenticated_root_path, alert: t("devise.failure.already_verified") if user_signed_in? && current_user.verified?
    end
end
