defmodule Paperhub.Repo.Migrations.AddProjects do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:projects, primary_key: false) do
      add :id, :identity, null: false, primary_key: true
      add :title, :text
      add :description, :text
      add :content, :map, default: %{}
      add :slug, :text

      add :inserted_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
    end

    create unique_index(:projects, [:slug], name: "projects_unique_slug_index")
  end

  def down do
    drop_if_exists unique_index(:projects, [:slug], name: "projects_unique_slug_index")

    drop table(:projects)
  end
end
