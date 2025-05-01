RSpec.describe Users::OnboardingController, :inertia do
  let(:user) { create(:user) }

  before do
    sign_in user, scope: :user
  end

  context "when GET /onboarding with unverified user" do
    it "renders the onboarding page" do
      get user_onboarding_path

      expect_inertia.to render_component("Users/Onboarding")
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
