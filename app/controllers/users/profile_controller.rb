module Users
  class ProfileController < ApplicationController
    def update
      if user_params[:avatar].present?
        current_user.update(user_params)
      else
        current_user.update(user_params.except(:avatar))
      end
      redirect_to documents_path, notice: "Profile was successfully updated."
    end

    private

      def user_params
        params.expect(user: [ :name, :avatar ])
      end
  end
end
