RSpec.describe UserPolicy, :policy do
  subject { described_class.new(user, team) }

  let(:user) { build(:user_verified) }
  let(:team) { create(:team, owner: user) }

  describe "#switch_team?" do
    context "when user is a member of the team" do
      before { team.add_member(user, role: :member) }

      it { is_expected.to permit_action(:switch_team) }
    end

    context "when team is nil" do
      let(:team) { nil }

      it { is_expected.to forbid_action(:switch_team) }
    end

    context "when user is not a member of the team" do
      let(:team) { build(:team) }

      it { is_expected.to forbid_action(:switch_team) }
    end
  end
end
