RSpec.describe Team do
  context "when checking if a user has the owner role" do
    let(:team) { create(:team) }

    it "returns true if the user is the owner" do
      expect(team).to have_owner_role(team.owner)
    end

    it "returns false if the user is not the owner" do
      other_user = create(:user)
      expect(team).not_to have_owner_role(other_user)
    end
  end

  context "when adding a member" do
    let(:team) { create(:team) }
    let(:user) { create(:user) }

    it "adds a user as a member with the specified role" do
      expect {
        team.add_member(user, role: :member)
      }.to change { team.members.count }.by(1)
    end

    it "does not add a user who is already a member" do
      team.add_member(user, role: :member)
      expect {
        team.add_member(user, role: :member)
      }.not_to change { team.members.count }
    end
  end
end
