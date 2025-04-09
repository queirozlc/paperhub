class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  inertia_share flash: -> { flash.to_hash }
  inertia_share if: :user_signed_in? do
    {
      user: current_user
    }
  end
end
