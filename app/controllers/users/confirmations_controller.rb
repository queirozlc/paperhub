class Users::ConfirmationsController < ApplicationController
  def show
    render inertia: "Confirmations/Show", props: { email: params.fetch(:email, "") }
  end
end
