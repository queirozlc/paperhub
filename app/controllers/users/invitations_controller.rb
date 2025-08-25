module Users
  class InvitationsController < ApplicationController
    def create
      ActsAsTenant.without_tenant do
        if (user_to_invite = User.find_by_email(invite_params[:email]))
          authorize user_to_invite, policy_class: Users::InvitationPolicy
          current_user.invite_for_team(user_to_invite, invitation_role: invite_params[:invitation_role])
          user_to_invite.invite!(current_user)
          redirect_to documents_path, notice: "User invited."
        else
          redirect_to documents_path, alert: "User not found."
        end
      end
    end

    def edit
      ActsAsTenant.without_tenant do
        invited_user = User.find_by_invitation_token(params[:invitation_token], true)
        if invited_user
          authorize invited_user, policy_class: Users::InvitationPolicy
          invited_user.accept_invitation!
          redirect_to documents_path, notice: "Invitation accepted."
        else
          redirect_to documents_path, inertia: {
            errors: {
              invitation_token: "Invalid invitation token."
            }
          }
        end
      end
    end

    def destroy
      ActsAsTenant.without_tenant do
        @user_invitation = User.find_by_email(params[:email])
      end

      if @user_invitation
        authorize @user_invitation, policy_class: Users::InvitationPolicy
        current_user.revoke_invitation!(@user_invitation)
        redirect_to documents_path, notice: "Invitation canceled."
      else
        redirect_to documents_path, alert: "Invitation not found."
      end
    end


    private

      def invite_params
        params.expect(user: [ :email, :invitation_role ])
      end
  end
end
