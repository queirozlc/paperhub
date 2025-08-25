RSpec.describe Users::OnboardingController, :inertia do
  let(:user) { create(:user) }

  before do
    sign_in user, scope: :user
  end

  context "when user is verified" do
    let(:user_verified) { create(:user_verified) }

    before do
      sign_in user_verified, scope: :user
    end

    describe "GET #onboarding" do
      it "halts and redirects to documents path" do
        get user_onboarding_path

        expect(response).to redirect_to(documents_path)
      end
    end
  end

  describe "GET #onboarding" do
    context "when current_user isn't verified" do
      it "renders the onboarding page" do
        get user_onboarding_path

        expect_inertia.to render_component("Users/Onboarding")
      end
    end
  end


  context "when PATCH /onboarding with unverified user" do
    it "updates the user and redirects to the root path" do
      patch user_onboarding_update_path, params: { user: { name: "New Name" } }

      expect(true).to satisfy {
        response.redirect? && user.name == "New Name"
      }
    end

    it "redirects to the onboarding page passing validation errors" do
      patch user_onboarding_update_path, params: { user: { name: "" } }
      expect(response).to redirect_to(user_onboarding_path)
    end
  end
end
