defmodule Paperhub.Accounts.Membership do
  use Ash.Resource,
    otp_app: :paperhub,
    domain: Paperhub.Accounts,
    extensions: [AshJason.Resource],
    data_layer: AshPostgres.DataLayer

  postgres do
    table "memberships"
    repo Paperhub.Repo

    references do
      reference :member, on_delete: :delete, index?: true
      reference :team, on_delete: :delete, index?: true
    end
  end

  resource do
    require_primary_key? false
  end

  attributes do
    attribute :role, :atom do
      allow_nil? false
      public? true
      constraints one_of: [:admin, :member]
    end

    timestamps()
  end

  relationships do
    belongs_to :member, Paperhub.Accounts.User, allow_nil?: false
    belongs_to :team, Paperhub.Accounts.Team, allow_nil?: false
  end
end
