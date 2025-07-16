RSpec.describe User do
  context "when looking up a user" do
    it "finds a user by email when the email condition is met" do
      user = create(:user)
      found_user = described_class.find_for_authentication(email: user.email)
      expect(found_user).to eq(user).and be_a(described_class)
    end

    it "creates a new user when the email condition is not met" do
      email = "john_doe@email.com"
      new_user = described_class.find_for_authentication(email:)

      expect(new_user).to be_a(described_class).and have_attributes(email:).and be_persisted
    end
  end

  context "when creating a team for a user" do
    let(:name) { "John" }

    it "creates a new personal team for the user" do
      user = create(:user)
      expect { user.new_personal_team(name:) }.to change { user.teams.count }.by(1)
    end

    it "does not create a new personal team if the user already has an active team" do
      user_with_team = create(:user_verified)

      user_with_team.new_personal_team(name:)

      expect { user_with_team.new_personal_team(name:) }.not_to change { user_with_team.teams.count }
    end

    it "does not create a new personal team if the name is blank" do
      user = create(:user)
      expect { user.new_personal_team({ name: "" }) }.not_to change { user.teams.count }
    end
  end

  context "when checking if user can invite someone" do
    let(:team) { create(:team) }
    let(:user) { create(:user) }

    it "allows inviting if the user is the owner of the active team" do
      team.owner.set_current_team team
      expect(team.owner.can_invite?).to be true
    end

    it "allows inviting if the user has an owner role in the active team" do
      create(:membership, team:, member: user, role: :owner)
      user.set_current_team team

      expect(user.can_invite?).to be true
    end

    it "does not allow inviting if the user is not the owner and has no owner role" do
      user.set_current_team team
      user.memberships.build(team:, role: :member)

      expect(user.can_invite?).to be false
    end

    it "does not allow inviting if the user has no active team" do
      expect(user.can_invite?).to be false
    end
  end
end
