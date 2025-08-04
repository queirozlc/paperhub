RSpec.describe User do
  describe ".find_for_authentication" do
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
  end

  describe ".new_personal_team" do
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

  describe ".can_invite?" do
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

  describe ".invite_for_team" do
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

  describe ".current_role" do
    context "when user has a team" do
      subject { user.current_role }

      let(:user) { create(:user_verified) }

      it { is_expected.to eq("owner") }
    end

    context "when user has no team" do
      subject { user.current_role }

      let(:user) { build(:user) }

      it { is_expected.to be_nil }
    end
  end

  describe "#transfer_ownership" do
    let(:user_to_delete) { create(:user) }

    context "when user is alone in a team" do
      let!(:team) { create(:team, owner: user_to_delete) }

      before do
        team.add_member(user_to_delete, role: :owner)
      end

      it "deletes the team" do
        expect { user_to_delete.transfer_ownership }.to change { Team.count }.by(-1)
        expect(Team.find_by(id: team.id)).to be_nil
      end
    end

    context "when user is the only owner in a team with multiple members" do
      let!(:team) { create(:team, owner: user_to_delete) }
      let!(:other_user) { create(:user) }

      before do
        team.add_member(user_to_delete, role: :owner)
        team.add_member(other_user, role: :member)
      end

      it "promotes another member to owner" do
        user_to_delete.transfer_ownership

        expect(team.reload.has_owner_role?(other_user)).to be true
        expect(team.has_owner_role?(user_to_delete)).to be true # user is still there until deletion
      end

      it "does not delete the team" do
        expect { user_to_delete.transfer_ownership }.not_to change { Team.count }
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
        expect { user_to_delete.transfer_ownership }.not_to change { Team.count }
      end
    end

    context "when user belongs to multiple teams with different scenarios" do
      let!(:solo_team) { create(:team, owner: user_to_delete) }
      let!(:team_needing_promotion) { create(:team, owner: user_to_delete) }
      let!(:team_with_other_owners) { create(:team, owner: user_to_delete) }
      let!(:member_1) { create(:user) }
      let!(:member_2) { create(:user) }
      let!(:other_owner) { create(:user) }

      before do
        # Solo team
        solo_team.add_member(user_to_delete, role: :owner)

        # Team needing promotion
        team_needing_promotion.add_member(user_to_delete, role: :owner)
        team_needing_promotion.add_member(member_1, role: :member)

        # Team with other owners
        team_with_other_owners.add_member(user_to_delete, role: :owner)
        team_with_other_owners.add_member(other_owner, role: :owner)
        team_with_other_owners.add_member(member_2, role: :member)
      end

      it "handles all scenarios correctly" do
        expect { user_to_delete.transfer_ownership }.to change { Team.count }.by(-1)

        # Solo team should be deleted
        expect(Team.find_by(id: solo_team.id)).to be_nil

        # Team needing promotion should promote member_1
        expect(team_needing_promotion.reload.has_owner_role?(member_1)).to be true

        # Team with other owners should remain unchanged
        expect(team_with_other_owners.reload.has_owner_role?(other_owner)).to be true
        expect(team_with_other_owners.has_owner_role?(member_2)).to be false
      end
    end

    context "when user has no teams" do
      it "does not raise an error" do
        expect { user_to_delete.transfer_ownership }.not_to raise_error
      end
    end
  end
end
