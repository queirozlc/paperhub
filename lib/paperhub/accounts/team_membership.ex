defmodule Paperhub.Accounts.TeamMembership do
  use Ash.Resource,
    domain: Paperhub.Accounts,
    otp_app: :paperhub,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "team_memberships"
    repo Paperhub.Repo

    references do
      reference :member, on_delete: :delete
      reference :team, on_delete: :delete
    end
  end

  actions do
    defaults [:read, :destroy, create: :*]
  end

  attributes do
    integer_primary_key :id

    attribute :role, :atom do
      constraints one_of: [:member, :admin]
    end
  end

  relationships do
    belongs_to :member, Paperhub.Accounts.User, allow_nil?: false
    belongs_to :team, Paperhub.Accounts.Team, allow_nil?: false
  end
end
