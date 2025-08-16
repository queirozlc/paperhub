RSpec.describe TeamPolicy, :policy do
  subject { described_class.new(user, user.active_team) }

  let(:user) { create(:user_verified) }

  describe "#destroy_member?" do
    context "when user is the owner of the team" do
      let(:other_user) { build(:user) }

      before do
        user.active_team.add_member(other_user, role: :owner)
      end

      it { is_expected.to permit_action(:destroy_member) }
    end
  end

  describe "#destroy?" do
    context "when user is the owner of the team but has only one team" do
      it { is_expected.to forbid_action(:destroy) }
    end

    context "when user is the owner of the team and has more than one team" do
      before do
        team = user.owned_teams.create(name: "Team 2")
        team.add_member(user, role: :owner)
      end

      it { is_expected.to permit_action(:destroy) }
    end
  end
end
