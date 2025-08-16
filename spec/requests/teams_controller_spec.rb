RSpec.describe TeamsController, :inertia do
  let(:user) { create(:user_verified) }

  before do
    sign_in user, scope: :user
  end

  describe "POST #create" do
    context "when creating with invalid params" do
      subject { response }

      let(:invalid_params) { { team: { name: "" } } }

      before { post teams_path, params: invalid_params }

      it { is_expected.to redirect_to(documents_path) }
    end

    context "when creating with valid params" do
      subject(:create_team) { post teams_path, params: valid_params }

      let(:valid_params) { { team: { name: "New team" } } }

      it "creates a new team" do
        expect { create_team }.to change(Team, :count).by(1)
      end

      it "sets the owner current team" do
        create_team
        expect(user.active_team).to eq(Team.last)
      end

      it "redirects to the documents path" do
        expect(create_team).to redirect_to(documents_path)
      end
    end
  end

  describe "PATCH #update" do
    let(:invalid_params) do
      { team: { name: "" } }
    end

    let(:valid_params) do
      { team: { name: "New name" } }
    end


    context "when updating with invalid params" do
      subject { response }

      before { patch team_path(user.active_team), params: invalid_params }

      it { is_expected.to redirect_to(documents_path) }

      it "renders the errors" do
        expect(user.active_team.reload.errors).to be_present
      end
    end

    context "when updating with valid params" do
      subject(:update_team) { patch team_path(user.active_team), params: valid_params }

      it "updates the team" do
        expect { update_team }.to change { user.active_team.reload.name }.to("New name")
      end

      it "redirects to the documents path" do
        expect(update_team).to redirect_to(documents_path)
      end
    end

    context "when updating with valid params and cover" do
      subject(:update_team) { patch team_path(user.active_team), params: valid_params_with_cover }

      let(:valid_params_with_cover) { { team: { name: "New name", cover: fixture_file_upload("test.png") } } }

      it "attaches the cover" do
        expect { update_team }.to change { user.active_team.cover.attached? }.to(true)
      end

      it "redirects to the documents path" do
        expect(update_team).to redirect_to(documents_path)
      end
    end
  end

  describe "DELETE #destroy_member" do
    context "when current user does not have owner role" do
      subject(:destroy_member) { delete destroy_member_teams_path(user.id) }

      let(:team_member) { create(:user_verified) }

      before do
        user.active_team.add_member(team_member)
        team_member.set_current_team user.active_team
        sign_in team_member, scope: :user
      end

      it "raises Pundit::NotAuthorizedError" do
        expect { destroy_member }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "when current user does have an owner role" do
      subject(:destroy_member) { delete destroy_member_teams_path(team_member.id) }

      let(:team_member) { build(:user) }

      before do
        user.active_team.add_member(team_member)
      end

      it "removes the member from the team" do
        expect { destroy_member }.to change { user.active_team.members.count }.by(-1)
      end

      it "redirects to the documents path" do
        expect(destroy_member).to redirect_to(documents_path)
      end
    end

    context "when the team is the active team of the member being removed" do
      subject(:destroy_member) { delete destroy_member_teams_path(team_member.id) }

      let(:team_member) { create(:user_verified, name: "Team member") }

      before do
        user.active_team.add_member(team_member)
        team_member.set_current_team user.active_team
      end

      it "removes the member from the team" do
        expect { destroy_member }.to change { user.active_team.members.count }.by(-1)
      end

      it "redirects to the documents path" do
        expect(destroy_member).to redirect_to(documents_path)
      end

      it "sets the active team to the first team of the member" do
        destroy_member
        expect(team_member.reload.active_team).to eq(team_member.owned_teams.first)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when current user does not have owner role" do
      subject(:destroy_team) { delete team_path(team.id) }

      let(:team) { create(:team) }

      before do
        team.add_member(user)
        user.set_current_team team
      end

      it "raises Pundit::NotAuthorizedError" do
        expect { destroy_team }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "when current user has owner role but does not have any other team" do
      subject(:destroy_team) { delete team_path(user.active_team) }

      it "raises Pundit::NotAuthorizedError" do
        expect { destroy_team }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "when team is the active team of other members" do
      subject(:destroy_team) { delete team_path(user.active_team) }

      let(:team_member) { create(:user_verified) }

      before do
        team_member.active_team.add_member(user)
        user.active_team.add_member(team_member)
        team_member.set_current_team user.active_team
      end

      it "destroys the team" do
        expect { destroy_team }.to change(Team, :count).by(-1)
      end

      it "sets the members active team to their first team" do
        destroy_team
        expect(team_member.reload.active_team).to eq(team_member.teams.first)
      end

      it "redirects to the documents path" do
        expect(destroy_team).to redirect_to(documents_path)
      end
    end
  end
end
