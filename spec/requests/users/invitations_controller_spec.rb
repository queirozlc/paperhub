RSpec.describe 'Users::InvitationsController', :inertia do
  describe '#create' do
    context "when user to invite is not found" do
      subject { response }

      let(:user) { create(:user_verified) }

      before do
        sign_in user, scope: :user
        post user_invitation_path, params: { user: { email: 'random@email.com', invitation_role: 'member' } }
      end

      it { is_expected.to redirect_to documents_path }
      it { expect(flash[:alert]).to eq("User not found.") }
    end

    context "when user is not authorized to perform the action" do
      subject(:call) { post user_invitation_path, params: { user: { email: user_to_invite.email, invitation_role:
        'member' } } }

      let(:team) { create(:team) }
      let(:user) { create(:user_verified) }
      let(:user_to_invite) { create(:user) }


      before do
        user.set_current_team team
        sign_in user, scope: :user
      end

      it "raises Pundit::NotAuthorizedError" do
        expect { call }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "when user to invite is found" do
      subject { response }

      let(:user) { create(:user_verified) }
      let(:user_to_invite) { create(:user) }

      before do
        sign_in user, scope: :user
        post user_invitation_path, params: { user: { email: user_to_invite.email, invitation_role: 'member' } }
      end

      it "invites the user" do
        user_to_invite.reload
        expect(user_to_invite.invited_team).to eq(user.active_team)
      end

      it { is_expected.to redirect_to documents_path }
      it { expect(flash[:notice]).to eq("User invited.") }
    end
  end

  describe "#edit" do
    subject { response }

    context "when there's not invite" do
      let(:user) { create(:user_verified) }
      let(:invitation_token) { "invalid token" }

      before do
        sign_in user, scope: :user
        get accept_user_invitation_path params: { invitation_token: invitation_token }
      end

      it { is_expected.to redirect_to documents_path }
    end

    context "when invited user is unauthorized to accept" do
      subject(:call) { get accept_user_invitation_path params: { invitation_token: invitation_token } }

      let(:user) { create(:user_verified) }
      let(:another_user) { create(:user) }
      let(:invitation_token) { "valid_token" }

      before do
        sign_in user, scope: :user
        allow(User).to receive(:find_by_invitation_token).with(invitation_token, true).and_return(another_user)
      end

      it "raises Pundit::NotAuthorizedError" do
        expect { call }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "when invited user accepts the invite" do
      let(:user) { create(:user_verified) }
      let(:invitation_token) { "invitation_token" }
      let(:invited_user) { create(:user_verified, invited_team: user.active_team, invitation_role: "member",
        invitation_token:) }

      before do
        sign_in invited_user, scope: :user
        allow(User).to receive(:find_by_invitation_token).with(invitation_token, true).and_return(invited_user)
        get accept_user_invitation_path params: { invitation_token: "invitation_token" }
      end

      it { is_expected.to redirect_to documents_path }

      it "accepts the invitation" do
        expect(invited_user.reload.active_team).to eq(user.active_team)
      end

      it "sets the invited team nil" do
        expect(invited_user.reload.invited_team).to be_nil
      end
    end
  end
end
