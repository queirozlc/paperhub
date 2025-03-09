defmodule Paperhub.Accounts do
  use Ash.Domain,
    otp_app: :paperhub

  resources do
    resource Paperhub.Accounts.Token

    resource Paperhub.Accounts.User do
      define :set_current_team, action: :set_current_team, args: [:team_id]
      define :get_user, action: :get_user, args: [:id]
    end

    resource Paperhub.Accounts.Team do
      define :create_default_team, action: :default_team
    end

    resource Paperhub.Accounts.Membership
  end
end
