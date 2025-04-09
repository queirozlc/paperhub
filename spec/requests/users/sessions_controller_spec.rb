require 'rails_helper'

RSpec.describe Users::SessionsController, :inertia do
  describe 'GET /sign_in' do
    it 'renders sign in inertia component' do
      get new_user_session_path

      expect_inertia.to render_component('Auth/SignIn')
    end
  end
end
