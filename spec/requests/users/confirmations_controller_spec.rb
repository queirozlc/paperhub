require 'rails_helper'

RSpec.describe Users::ConfirmationsController, :inertia do
  describe '#show' do
    let(:user) { create(:user) }

    context "when user is already logged in" do
      include_context 'when user is logged in'

      it 'redirects to the root path' do
        get verify_email_url, params: { email: user.email }

        expect(response).to redirect_to(authenticated_root_path)
      end
    end
  end
end
