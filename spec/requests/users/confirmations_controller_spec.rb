RSpec.describe Users::ConfirmationsController, :inertia do
  let(:user) { create(:user) }

  before do
    sign_in user, scope: :user
  end

  describe '#show' do
    context "when user is already logged in" do
      it 'redirects to the root path' do
        get verify_email_url, params: { email: user.email }

        expect(response).to redirect_to(authenticated_root_path)
      end
    end
  end
end
