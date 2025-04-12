class Users::BaseController < ApplicationController
  skip_before_action :authenticate_verified_user!
end
