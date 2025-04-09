class HomeController < ApplicationController
  def index
    render inertia: "Home/Index"
  end
end
