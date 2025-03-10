defmodule Paperhub.Accounts do
  use Ash.Domain,
    otp_app: :paperhub

  resources do
    resource Paperhub.Accounts.Token

    resource Paperhub.Accounts.User do
      define :set_current_team, action: :set_current_team, args: [:team_id]
    end

    resource Paperhub.Accounts.Team do
      define :create_default_team, action: :default_team
    end

    resource Paperhub.Accounts.Membership do
      define :create_membership, action: :create
      define :team_member?, action: :team_member?, args: [:member_id, :team_id]
    end
  end
end
