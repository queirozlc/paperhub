defmodule Paperhub.OrganizationsFixtures do
  import Paperhub.AccountsFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Paperhub.Organizations` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: Faker.Company.name()
      })
      |> Paperhub.Organizations.create_team(user)

    team
  end

  def random_name, do: Faker.Company.name()
end
