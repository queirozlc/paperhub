RSpec.describe UsersController, :inertia do
  let(:user) { create(:user_verified) }

  before { sign_in user, scope: :user }

  describe "PATCH #switch_team" do
    context "when team is not found" do
      subject(:switch_team) { patch switch_team_user_path(id: 0) }

      it "raises a Pundit::NotAuthorizedError" do
        expect { switch_team }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "when user is not a member of the team" do
      subject(:switch_team) { patch switch_team_user_path(id: team.id) }

      let(:team) { create(:team) }

      it "raises a Pundit::NotAuthorizedError" do
        expect { switch_team }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "when user is a member of the team" do
      subject { response }

      let(:team) { create(:team) }

      before do
        team.add_member(user, role: :member)
        patch switch_team_user_path(id: team.id)
      end

      it { is_expected.to redirect_to documents_path }

      it "updates the current team" do
        expect(user.active_team).to eq(team)
      end
    end
  end

  describe "DELETE #destroy" do
    subject(:destroy_user) { delete user_path(user) }

    it "deletes the user" do
      expect { destroy_user }.to change(User, :count).by(-1)
    end

    it "redirects to the root path" do
      destroy_user
      expect(response).to redirect_to(root_path)
    end
  end
end
