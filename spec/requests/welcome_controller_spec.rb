RSpec.describe 'WelcomeController', :inertia do
  describe "GET #index" do
    context "when user is already authenticated" do
      subject { response }

      before do
        sign_in create(:user), scope: :user
        get root_path
      end

      it { is_expected.to redirect_to documents_path }
    end

    it "renders the welcome page" do
      get root_path
      expect_inertia.to render_component "Welcome/Index"
    end
  end
end
