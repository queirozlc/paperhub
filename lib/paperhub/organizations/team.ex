defmodule Paperhub.Organizations.Team do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %{
          id: integer(),
          name: String.t(),
          owner: Paperhub.Accounts.User.t(),
          members: [Paperhub.Accounts.User.t()]
        }

  @derive {Jason.Encoder, only: [:id, :name, :owner, :members]}
  schema "teams" do
    field :name, :string
    belongs_to :owner, Paperhub.Accounts.User, foreign_key: :owner_id

    many_to_many :members, Paperhub.Accounts.User,
      join_through: Paperhub.Organizations.Membership,
      join_keys: [team_id: :id, member_id: :id],
      on_delete: :delete_all,
      unique: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :owner_id])
    |> validate_required([:name, :owner_id])
    |> foreign_key_constraint(:owner_id)
  end
end
