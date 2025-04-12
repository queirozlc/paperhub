class Users::ConfirmationsController < Users::BaseController
  before_action :require_unauthenticated_user!

  def show
    render inertia: "Users/Confirmations", props: { email: params.expect(:email) }
  end
end
