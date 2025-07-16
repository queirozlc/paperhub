module Users
  class InvitationPolicy
    attr_reader :user

    def initialize(user, _record)
      @user = user
    end

    def create?
      user.can_invite?
    end
  end
end
