class UserPolicy < ApplicationPolicy
  def destroy?
    record == user
  end

  def switch_team?
    return false if record.nil?

    user.teams.include?(record)
  end
end
