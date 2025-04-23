require 'rails_helper'

RSpec.describe Membership do
  it "returns true if the user is an owner of the team" do
    user = create(:user_verified)

    expect(described_class.owner?(user, user.active_team)).to be true
  end

  it "returns false if the user is not an owner of the team" do
    user = create(:user_verified)
    team = create(:team)

    create(:membership, member: user, team: team, role: :member)

    expect(described_class.owner?(user, team)).to be false
  end
end
