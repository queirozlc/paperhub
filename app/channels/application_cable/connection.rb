module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.info "Connected... #{current_user.inspect}"
    end

    def find_verified_user
      if verified_user = env["warden"].user
        verified_user
      else
        reject_unauthorized_connection
        nil
      end
    end
  end
end
