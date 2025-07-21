RSpec.describe Users::SessionsController, :inertia do
  describe '#new' do
    context 'when user is not logged in' do
      before { get new_user_session_path }

      it { expect_inertia.to render_component("Users/Sessions") }
    end

    context 'when an unverified user is logged in' do
      subject { response }

      let(:user) { create(:user) }

      before do
        sign_in user, scope: :user
        get new_user_session_path
      end

      it { is_expected.to redirect_to user_onboarding_path }
    end

    context 'when a verified user is logged is' do
      subject { response }

      let(:user) { create(:user_verified) }

      before do
        sign_in user, scope: :user
        get new_user_session_path
      end

      it { is_expected.to redirect_to documents_path }
    end
  end
end
