module Users
  class InvitationsController < Users::BaseController
    def create
      authorize :invitation

      if (user_to_invite = User.find_by_email(invite_params[:email]))
        current_user.invite!(user_to_invite)
      else
        redirect_to authenticated_root_path, notice: "User not found."
      end
    end

    private

      def invite_params
        params.expect(user: [ :email ])
      end
  end
end
