RSpec.describe TeamsController, :inertia do
  describe "POST #create" do
    let(:user) { create(:user_verified) }

    before do
      sign_in user, scope: :user
    end

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
end
