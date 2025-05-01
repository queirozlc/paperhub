module ControllerMacros
  def login_user(user = nil)
    before do
      sign_in(user || create(:user), scope: :user)
    end
  end
end
