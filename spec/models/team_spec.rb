RSpec.describe Team do
  let(:team) { create(:team) }

  describe "#has_owner_role?" do
    subject { team }

    context "when user is the owner" do
      it { is_expected.to have_owner_role(team.owner) }
    end

    context "when user is not the owner" do
      it { is_expected.not_to have_owner_role(build(:user)) }
    end
  end

  describe "#add_member" do
    subject { team }

    let(:user) { build(:user) }

    context "when adding a member with a valid role" do
      it "adds the user as a member" do
        expect {
          team.add_member(user)
        }.to change { team.members.count }.by(1)
      end
    end

    context "when adding a member who is already a member" do
      before { team.add_member(user) }

      it "does not add the user again" do
        expect {
          team.add_member(user, role: :member)
        }.not_to change { team.members.count }
      end
    end

    context "when role is not specified" do
      it "adds the user as a member by default" do
        team.add_member(user)
        expect(team.memberships.last&.role).to eq("member")
      end
    end
  end

  describe "#already_member?" do
    subject { team }

    let(:user) { build(:user) }

    context "when user is a member of a team" do
      before { team.add_member(user) }

      it { is_expected.to be_already_member(user) }
    end

    context "when user is not a member of a team" do
      it { is_expected.not_to be_already_member(user) }
    end
  end

  describe "#remove_member" do
    let(:user) { create(:user_verified) }

    context "when member is the owner" do
      let(:team) { user.active_team }

      it "does not removes the owner" do
        expect {
          team.remove_member(user)
        }.not_to change { team.members.count }
      end
    end

    context "when the team is not the active team" do
      before { team.add_member(user) }

      it "removes the member" do
        expect {
          team.remove_member(user)
        }.to change { team.members.count }.by(-1)
      end
    end

    context "when the team is the active team of the member" do
      before do
        team.add_member(user)
        user.set_current_team(team)
      end

      it "removes the member" do
        expect {
          team.remove_member(user)
        }.to change { team.members.count }.by(-1)
      end

      it "sets the first owned team as the active team of the member" do
        team.remove_member(user)
        expect(user.active_team).to eq(user.owned_teams.first)
      end
    end
  end
end
