defmodule Paperhub.ProjectsFixtures do
  import Paperhub.OrganizationsFixtures, only: [team_fixture: 0]

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Paperhub.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    team = team_fixture()

    {:ok, project} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title",
        visibility: :public
      })
      |> Paperhub.Projects.create_project(team)

    project
  end
end
