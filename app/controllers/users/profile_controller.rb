module Users
  class ProfileController < ApplicationController
    def update
      current_user.avatar.attach(user_params[:avatar]) if user_params[:avatar].present?

      if current_user.update(user_params.except(:avatar))
        redirect_to documents_path, notice: "Profile was successfully updated."
      else
        redirect_to documents_path, inertia: { errors: current_user.errors }
      end
    end

    private

      def user_params
        params.expect(user: [ :name, :avatar ])
      end
  end
end
