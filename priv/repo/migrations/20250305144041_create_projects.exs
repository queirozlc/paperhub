defmodule Paperhub.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :visibility, :string, null: false
      add :title, :string
      add :description, :string
      add :team_id, references(:teams, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end

    create index(:projects, [:team_id])
    create unique_index(:projects, [:team_id, :id], name: :unique_team_project_idx)
  end
end
