RSpec.describe Users::SessionsController, :inertia do
  describe 'GET /sign_in' do
    context 'when user is not logged in' do
      it 'renders sign in inertia component' do
        get new_user_session_path

        expect_inertia.to render_component('Users/Sessions')
      end
    end

    context 'when user is logged in' do
      login_user

      it 'redirects to the root path' do
        get new_user_session_path
        expect(response).to redirect_to(authenticated_root_path)
      end
    end
  end
end
