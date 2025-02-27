defmodule Paperhub.Accounts do
  use Ash.Domain,
    otp_app: :paperhub

  resources do
    resource Paperhub.Accounts.Token
    resource Paperhub.Accounts.User

    resource Paperhub.Accounts.Team do
      define :create_team, action: :create, args: [:name]
    end

    resource Paperhub.Accounts.TeamMembership
  end
end
