class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, :authenticate_verified_user!
  before_action :require_unauthenticated_user!

  def index
    render inertia: "Welcome/Index"
  end
end
