defmodule Paperhub.Repo.Migrations.AddCurrentTeamToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :current_team_id, references(:teams)
    end

    create index(:users, [:current_team_id])
  end
end
