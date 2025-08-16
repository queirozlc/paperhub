RSpec.describe 'Users::InvitationsController', :inertia do
  let(:user) { create(:user_verified) }

  before { sign_in user, scope: :user }


  describe '#create' do
    context "when user to invite is not found" do
      subject { response }

      before { post user_invitation_path, params: { user: { email: 'random@email.com', invitation_role: 'member' } } }

      it { is_expected.to redirect_to documents_path }
      it { expect(flash[:alert]).to eq("User not found.") }
    end

    context "when user is not authorized to perform the action" do
      subject(:call) { post user_invitation_path, params: { user: { email: user_to_invite.email, invitation_role:
        'member' } } }

      let(:team) { create(:team) }
      let(:user_to_invite) { create(:user) }


      before { user.set_current_team team }

      it "raises Pundit::NotAuthorizedError" do
        expect { call }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "when user to invite is found" do
      subject { response }

      let(:user_to_invite) { create(:user) }

      before { post user_invitation_path, params: { user: { email: user_to_invite.email, invitation_role: 'member' } } }

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
      let(:invitation_token) { "invalid token" }

      before { get accept_user_invitation_path params: { invitation_token: invitation_token } }

      it { is_expected.to redirect_to documents_path }
    end

    context "when invited user is unauthorized to accept" do
      subject(:call) { get accept_user_invitation_path params: { invitation_token: invitation_token } }

      let(:another_user) { create(:user) }
      let(:invitation_token) { "valid_token" }

      before { allow(User).to receive(:find_by_invitation_token).with(invitation_token, true).and_return(another_user) }

      it "raises Pundit::NotAuthorizedError" do
        expect { call }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "when invited user accepts the invite" do
      let(:invitation_token) { "invitation_token" }
      let(:invited_user) { create(:user_verified, invited_team: user.active_team, invitation_role: "member",
        invitation_token:) }

      before do
        sign_in invited_user, scope: :user
        allow(User).to receive(:find_by_invitation_token).with(invitation_token, true).and_return(invited_user)
        get accept_user_invitation_path params: { invitation_token: "invitation_token" }
      end

      it { is_expected.to redirect_to documents_path }

      it "sets the invited user's active team to the current user's active team" do
        expect(invited_user.reload.active_team).to eq(user.active_team)
      end

      it "sets the invited user's invited team to nil" do
        expect(invited_user.reload.invited_team).to be_nil
      end
    end
  end

  describe "#destroy" do
    subject { response }

    context "when there's not invite" do
      before { get remove_user_invitation_path params: { email: "random@email.com" } }

      it { is_expected.to redirect_to documents_path }
    end

    context "when invited user was not invited by the current user" do
      subject(:action) { get remove_user_invitation_path params: { email: invited_user.email } }

      let(:invited_user) { create(:user_verified) }


      it "raises Pundit::NotAuthorizedError" do
        expect { action }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "when user revokes the invitation" do
      subject { response }

      before { get remove_user_invitation_path params: { email: invited_user.email } }

      let(:invited_user) { create(:user_verified, invited_by: user) }

      it { is_expected.to redirect_to documents_path }

      it "revokes the invitation" do
        expect(invited_user.reload.invited_by).to be_nil
      end
    end
  end
end
