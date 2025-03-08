defmodule Paperhub.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Paperhub.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(team, attrs \\ %{}) do
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
