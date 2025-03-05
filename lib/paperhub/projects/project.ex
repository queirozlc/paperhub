defmodule Paperhub.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :title, :description, :visibility, :hash_id]}
  schema "projects" do
    field :description, :string
    field :title, :string
    field :hash_id, :string, virtual: true
    field :visibility, Ecto.Enum, values: [:public, :private, :restricted], default: :public
    belongs_to :team, Paperhub.Organizations.Team

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:visibility, :title, :description, :team_id])
    |> validate_required([:visibility, :team_id])
    |> foreign_key_constraint(:team_id)
    |> validate_inclusion(:visibility, [:public, :private, :restricted])
  end
end
