defmodule Paperhub.Organizations.Membership do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "memberships" do
    field :role, Ecto.Enum, values: [:admin, :member], default: :member
    belongs_to :member, Paperhub.Accounts.User, foreign_key: :member_id
    belongs_to :team, Paperhub.Organizations.Team

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(membership, attrs) do
    membership
    |> cast(attrs, [:role, :member_id, :team_id])
    |> validate_required([:member_id, :team_id])
    |> foreign_key_constraint(:member_id)
    |> foreign_key_constraint(:team_id)
    |> unique_constraint([:member_id, :team_id])
    |> validate_inclusion(:role, [:admin, :member])
  end
end
