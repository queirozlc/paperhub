class ApplicationController < ActionController::Base
  include Pundit::Authorization
  set_current_tenant_through_filter
  allow_browser versions: :modern
  before_action :set_tenant
  before_action :authenticate_user!
  before_action :authenticate_verified_user!

  inertia_share flash: -> { flash.to_hash }
  inertia_share if: :user_signed_in? do
    {
      user: -> { serialized_user }
    }
  end

  def require_unauthenticated_user!
    redirect_to documents_path, alert: t("devise.failure.already_authenticated") if user_signed_in?
  end


  def after_magic_link_sent_path_for(resource)
    verify_email_path(email: resource.email)
  end

  def new_user_verification_path
    user_onboarding_path
  end

  private
    def set_tenant
      return unless current_user
      Current.user = current_user
    end

    def serialized_user
      return unless current_user

      current_user.as_json(
        only: %i[id email name active_team_id]
      )
    end
end
