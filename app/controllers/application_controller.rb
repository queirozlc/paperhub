class ApplicationController < ActionController::Base
  include Pundit::Authorization
  set_current_tenant_through_filter
  allow_browser versions: :modern
  before_action :set_tenant
  before_action :authenticate_user!
  before_action :authenticate_verified_user!
  # :nocov:
  unless Rails.env.production?
    around_action :n_plus_one_detection

    def n_plus_one_detection
      Prosopite.scan
      yield
    ensure
      Prosopite.finish
    end
  end
  # :nocov:

  inertia_share flash: -> { flash.to_hash }
  inertia_share if: :user_signed_in? do
    {
      user: -> { serialized_user }
    }
  end

  def require_unauthenticated_user!
    redirect_to documents_path, alert: t("devise.failure.already_authenticated") if user_signed_in?
  end


  # :nocov: Both skipped because they're used by devise
  def after_magic_link_sent_path_for(resource)
    verify_email_path(email: resource.email)
  end

  def new_user_verification_path
    user_onboarding_path
  end
  # :nocov:

  private
    def set_tenant
      Current.user = current_user if user_signed_in?
    end

    def serialized_user
      current_user.as_json(
        only: %i[id email name active_team_id]
      ).merge(avatar: user_avatar(current_user), role: current_user.role_in(current_user.active_team))
    end

    def user_avatar(user)
      return if user.avatar.blank?

      public_cdn_url(user.avatar)
    end
end
