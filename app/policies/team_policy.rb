class TeamPolicy < ApplicationPolicy
  def destroy?
    record.has_owner_role?(user) && user.owned_teams.count > 1
  end

  def destroy_member?
    record.has_owner_role?(user)
  end
end
