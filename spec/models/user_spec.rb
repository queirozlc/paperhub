require 'rails_helper'

RSpec.describe User, type: :model do
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
    let (:user) { create(:user) }
    let (:name) { "John" }

    it "creates a new personal team for the user" do
      expect { user.new_personal_team(name) }.to change { user.teams.count }.by(1)
    end

    it "does not create a new personal team if the user already has an active team" do
      user_with_team = create(:user_verified)

      user_with_team.new_personal_team(name)

      expect { user_with_team.new_personal_team(name) }.not_to change { user_with_team.teams.count }
    end

    it "does not create a new personal team if the name is blank" do
      expect { user.new_personal_team("") }.not_to change { user.teams.count }
    end
  end
end
