defmodule Paperhub.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members, primary_key: false) do
      add :role, :string, null: false
      add :member_id, references(:users, on_delete: :nothing), null: false
      add :team_id, references(:teams, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:members, [:member_id])
    create index(:members, [:team_id])
    create unique_index(:members, [:member_id, :team_id])
  end
end
