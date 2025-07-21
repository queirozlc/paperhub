RSpec.describe Users::InvitationPolicy do
  subject { described_class.new(user, invited_user) }

  let(:user) { create(:user_verified) }
  let(:invited_user) { build(:user_verified) }

  describe ".create?" do
    context "when user is the owner" do
      it { is_expected.to permit_action(:create) }
    end

    context "when user is a team member with owner role" do
      let(:team) { create(:team, owner: user) }

      before do
        team.add_member(user, role: :owner)
        user.set_current_team team
      end

      it { is_expected.to permit_action(:create) }
    end

    context "when there's no active team" do
      before { user.set_current_team nil }

      it { is_expected.to forbid_action(:create) }
    end

    context "when user is a member of the team" do
      before { user.active_team.add_member(invited_user, role: :member) }

      it { is_expected.to forbid_action(:create) }
    end
  end

  describe ".edit?" do
    context "when invited user is the current user" do
      subject { described_class.new(invited_user, invited_user) }

      it { is_expected.to permit_action(:edit) }
    end

    context "when invited user is different from current user" do
      it { is_expected.to forbid_action(:edit) }
    end
  end
end
