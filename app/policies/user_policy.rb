class UserPolicy < ApplicationPolicy
  def switch_team?
    if record.nil?
      false
    else
      user.teams.include?(record)
    end
  end
end
