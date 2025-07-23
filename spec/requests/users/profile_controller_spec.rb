RSpec.describe Users::ProfileController, :inertia do
  describe "PATCH #update" do
    let(:user) { create(:user_verified) }

    before do
      sign_in user, scope: :user
    end

    context "when avatar is not present" do
      subject(:update_user) { patch users_profile_path, params: valid_params }

      let(:valid_params) { { user: { name: "Updated name" } } }

      it "updates the user's name" do
        expect { update_user }.to change(user, :name).from(user.name).to("Updated name")
      end

      it "does not update the user's avatar" do
        expect { update_user }.not_to change(user, :avatar)
      end

      it "redirects to the documents path" do
        expect(update_user).to redirect_to(documents_path)
      end
    end

    context "when user updates avatar" do
      let(:valid_params) { { user: { avatar: fixture_file_upload("test.png") } } }

      before { patch users_profile_path, params: valid_params }

      it "updates the user's avatar" do
        expect(user.avatar).to be_attached
      end

      it { is_expected.to redirect_to(documents_path) }
    end
  end
end
