RSpec.describe User do
  describe "#find_for_authentication" do
    context "when user exists" do
      it "finds a user by email" do
        user = create(:user)
        found_user = described_class.find_for_authentication(email: user.email)
        expect(found_user).to eq(user).and be_a(described_class)
      end
    end

    context "when user does not exists yet" do
      it "creates a new user when the email" do
        email = "john_doe@email.com"
        new_user = described_class.find_for_authentication(email:)

        expect(new_user).to be_a(described_class).and have_attributes(email:).and be_persisted
      end
    end

    context "when email is not passed" do
      it "does nothing" do
        expect(described_class.find_for_authentication(email: nil)).to be_nil
      end
    end

    context "when passing something different than an email" do
      it "does nothing" do
        expect(described_class.find_for_authentication(name: "John Doe")).to be_nil
      end
    end
  end

  describe "#with_role" do
    let(:user) { create(:user_verified) }

    context "when the user has no team" do
      subject { described_class.with_role }

      let(:user) { build(:user) }

      it { is_expected.to be_empty }
    end


    context "when the user has a team" do
      subject(:users) { described_class.with_role }

      it { is_expected.to eq([ user ]) }

      it "returns the role of the user" do
        users.each do |user|
          expect(user.role_in(user.active_team)).to eq("owner")
        end
      end
    end
  end

  describe "#with_team" do
    let(:user) { create(:user_verified) }

    context "when the user has a team" do
      subject { described_class.with_role.with_team(user.active_team) }

      it { is_expected.to eq([ user ]) }
    end

    context "when the user has no team" do
      subject { described_class.with_role.with_team(build(:team)) }

      it { is_expected.to be_empty }
    end
  end

  describe "#new_personal_team" do
    let(:name) { "John" }

    context "when user does not have a team yet" do
      let(:user) { create(:user) }

      it { expect { user.new_personal_team(name:) }.to change { user.teams.count }.by(1) }
    end

    context "when the user already has an active team" do
      let(:user_with_team)  { create(:user_verified) }

      it { expect { user_with_team.new_personal_team(name:) }.not_to change { user_with_team.teams.count } }
    end

    context "when user's name is blank" do
      let(:user)  { build(:user) }

      it { expect { user.new_personal_team({ name: "" }) }.not_to change { user.teams.count } }
    end
  end

  describe "#can_invite?" do
    context "when user owns his active team" do
      let(:user) { create(:user_verified) }
      let(:invited_user) { build(:user) }

      it { expect(user.can_invite?(invited_user)).to be true }
    end

    context "when user has an owner role in the active team" do
      let(:user) { create(:user_verified) }
      let(:invited_user) { build(:user) }

      before do
        team = create(:team)
        team.add_member(user, role: :owner)
        user.set_current_team team
      end

      it { expect(user.can_invite?(invited_user)).to be true }
    end

    context "when user has no active team" do
      let(:user_without_team) { build(:user) }
      let(:invited_user) { build(:user) }

      it { expect(user_without_team.can_invite?(invited_user)).to be false }
    end

    context "when user is already a member of the active team" do
      let(:user) { create(:user_verified) }
      let(:invited_user) { create(:user) }

      before do
        user.active_team.add_member(invited_user, role: :member)
      end

      it { expect(user.can_invite?(invited_user)).to be false }
    end
  end

  describe "#invite_for_team" do
    subject { invited_user }

    before { user.invite_for_team invited_user, invitation_role: :member }

    context "when user has no active team" do
      let(:user) { build(:user) }
      let(:invited_user) { build(:user) }

      it { is_expected.to have_attributes(invited_team: nil, invitation_role: nil) }
    end

    context "when user can invite another user" do
      let(:user) { create(:user_verified) }
      let(:invited_user) { build(:user) }

      it { is_expected.to have_attributes(invited_team: user.active_team, invitation_role: "member") }
    end
  end

  describe "#role_in" do
    context "when user has a team" do
      subject { user.role_in(user.active_team) }

      let(:user) { create(:user_verified) }

      it { is_expected.to eq("owner") }
    end

    context "when user has no team" do
      subject { user.role_in(user.active_team) }

      let(:user) { build(:user) }

      it { is_expected.to be_nil }
    end
  end

  describe "#transfer_ownership" do
    let(:user_to_delete) { create(:user) }

    context "when user is alone in a team" do
      let!(:team) { create(:team, owner: user_to_delete) }

      it "deletes the team" do
        expect { user_to_delete.transfer_ownership }.to change(Team, :count).by(-1)
        .and change { Team.find_by(id: team.id) }.to be_nil
      end
    end

    context "when user is the only owner in a team with multiple members" do
      let!(:team) { create(:team, owner: user_to_delete) }
      let!(:other_user) { create(:user) }

      before do
        team.add_member(other_user, role: :member)
      end

      it "promotes another member to owner" do
        user_to_delete.transfer_ownership
        expect(team.reload.has_owner_role?(other_user)).to be true
      end

      it "does not delete the team" do
        expect { user_to_delete.transfer_ownership }.not_to change(Team, :count)
      end
    end

    context "when team has other owners" do
      let!(:team) { create(:team, owner: user_to_delete) }
      let!(:other_owner) { create(:user) }
      let!(:member) { create(:user) }

      before do
        team.add_member(user_to_delete, role: :owner)
        team.add_member(other_owner, role: :owner)
        team.add_member(member, role: :member)
      end

      it "does not promote anyone" do
        expect { user_to_delete.transfer_ownership }.not_to change {
          team.memberships.where(role: :owner).count
        }
      end

      it "does not delete the team" do
        expect { user_to_delete.transfer_ownership }.not_to change(Team, :count)
      end
    end

    context "when user has no teams" do
      it "does not raise an error" do
        expect { user_to_delete.transfer_ownership }.not_to raise_error
      end
    end
  end
end
