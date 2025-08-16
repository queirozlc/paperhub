class UserPolicy < ApplicationPolicy
  def switch_team?
    return false if record.nil?

    user.teams.include?(record)
  end
end
