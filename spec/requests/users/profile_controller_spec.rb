RSpec.describe Users::ProfileController do
  let(:user) { create(:user_verified) }
  let(:team) { create(:team, owner: user) }

  before do
    sign_in user, scope: :user
  end

  describe 'PATCH #update' do
    let(:valid_params) { { user: { active_team_id: team.id } } }

    it "updates the user's active team" do
      expect {
          patch users_team_path(user), params: valid_params
        }.to change(user, :active_team).from(user.active_team).to(team)
    end

    it "redirects to the authenticated root path" do
      patch users_team_path(user), params: valid_params
      expect(response).to redirect_to(documents_path)
    end
  end
end
