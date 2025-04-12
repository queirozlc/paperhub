# Current is supposed to be a singleton "dummy" class that holds the current user just
# make the tenant to be required in runtime
class Current < ActiveSupport::CurrentAttributes
  attribute :user

  # Sets the user and associated account in the Current object.
  # Also sets the current tenant for ActsAsTenant.
  def user=(user)
    super(user)
    ActsAsTenant.current_tenant = user&.active_team
  end
end
