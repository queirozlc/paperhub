defmodule Paperhub.Repo.Migrations.CreateTeamsAndMemberships do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string, null: false
      add :owner_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:teams, [:owner_id])

    create table(:memberships, primary_key: false) do
      add :role, :string, null: false
      add :member_id, references(:users, on_delete: :nothing), null: false
      add :team_id, references(:teams, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:memberships, [:member_id])
    create index(:memberships, [:team_id])
    create unique_index(:memberships, [:member_id, :team_id])
  end
end
