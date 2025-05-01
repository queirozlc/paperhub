RSpec.describe TeamsController, :inertia do
  let(:user) { create(:user_verified) }

  before do
    sign_in user, scope: :user
  end

  describe "POST #create" do
    let(:valid_attributes) { {
      name: "New team"
    }}


    it "creates a new team without cover image" do
      expect {
        post teams_url, params: { team: valid_attributes }
      }.to change(Team, :count).by(1)
    end

    it "sets the owner current team" do
      post teams_url, params: { team: valid_attributes }

      expect(user.active_team).to eq(Team.last)
    end

    it "redirects to the authenticated root path" do
      post teams_url, params: { team: valid_attributes }

      expect(response).to redirect_to(authenticated_root_url)
    end
  end
end
