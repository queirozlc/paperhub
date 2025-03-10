defmodule Paperhub.Accounts.Membership do
  use Ash.Resource,
    otp_app: :paperhub,
    domain: Paperhub.Accounts,
    extensions: [AshJason.Resource],
    data_layer: AshPostgres.DataLayer

  require Ash.Query

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

  actions do
    default_accept [:member_id, :team_id, :role]
    defaults [:read, :create]

    action :team_member? do
      argument :member_id, :integer, allow_nil?: false
      argument :team_id, :integer, allow_nil?: false
      returns :boolean

      run fn %{arguments: %{member_id: member_id, team_id: team_id}}, _ ->
        Ash.Query.new(__MODULE__)
        |> Ash.Query.filter(member_id == ^member_id)
        |> Ash.Query.filter(team_id == ^team_id)
        |> Ash.read_one!()
        |> case do
          nil ->
            {:ok, false}

          _ ->
            {:ok, true}
        end
      end
    end
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
