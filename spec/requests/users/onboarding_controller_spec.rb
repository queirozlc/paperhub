RSpec.describe Users::OnboardingController, :inertia do
  context "when GET /onboarding with unverified user" do
    include_context "when user is logged in"

    it "renders the onboarding page" do
      get user_onboarding_path

      expect_inertia.to render_component("Users/Onboarding")
    end
  end

  context "when PATCH /onboarding with unverified user" do
    include_context "when user is logged in"

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
