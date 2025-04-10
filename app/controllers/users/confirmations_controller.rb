class Users::ConfirmationsController < ApplicationController
  before_action :require_unauthenticated

  def show
    render inertia: "Confirmations/Show", props: { email: params.fetch(:email, "") }
  end



  private
    def require_unauthenticated
      return unless user_signed_in?

      redirect_to authenticated_root_path, flash: { error: "You are already signed in." }
    end
end
