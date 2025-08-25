module Users
  class InvitationPolicy < ApplicationPolicy
    def create?
      user.can_invite? record
    end

    def edit?
      record.id == user.id
    end

    def destroy?
      record.invited_by_id == user.id
    end
  end
end
