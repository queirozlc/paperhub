RSpec.describe Team do
  describe ".has_owner_role?" do
    subject { team }

    let(:team) { create(:team) }


    context "when user is the owner" do
      it { is_expected.to have_owner_role(team.owner) }
    end

    context "when user is not the owner" do
      it { is_expected.not_to have_owner_role(create(:user)) }
    end
  end

  describe ".add_member" do
    subject { team }

    let(:team) { create(:team) }
    let(:user) { build(:user) }

    context "when adding a member with a valid role" do
      it "adds the user as a member" do
        expect {
          team.add_member(user, role: :member)
        }.to change { team.members.count }.by(1)
      end
    end

    context "when adding a member who is already a member" do
      before { team.add_member(user, role: :member) }

      it "does not add the user again" do
        expect {
          team.add_member(user, role: :member)
        }.not_to change { team.members.count }
      end
    end
  end

  describe ".already_member?" do
    subject { team }

    let(:team) { create(:team) }
    let(:user) { build(:user) }

    context "when user is a member of a team" do
      before { team.add_member(user, role: :member) }

      it { is_expected.to be_already_member(user) }
    end

    context "when user is not a member of a team" do
      it { is_expected.not_to be_already_member(user) }
    end
  end
end
