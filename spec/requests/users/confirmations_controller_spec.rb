RSpec.describe Users::ConfirmationsController, :inertia do
  let(:user) { create(:user) }

  describe '#show' do
    subject { response }

    context "when user is already logged in" do
      before do
        sign_in user, scope: :user
        get verify_email_url, params: { email: user.email }
      end

      it { is_expected.to redirect_to documents_path }
    end

    context "when user is not logged in" do
      before { get verify_email_url, params: { email: user.email } }

      it { expect_inertia.to render_component "Users/Confirmations" }
    end
  end
end
