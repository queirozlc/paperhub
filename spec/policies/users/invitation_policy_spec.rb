RSpec.describe Users::InvitationPolicy do
  subject { described_class.new(user, nil) }

  context "when the user is an admin" do
    let(:user) { create(:user_verified) }

    it { is_expected.to permit_actions([ :create ]) }
  end
end
