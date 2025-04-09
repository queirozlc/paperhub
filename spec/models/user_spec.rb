require 'rails_helper'

RSpec.describe User, type: :model do
  describe "find_for_authentication" do
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
end
