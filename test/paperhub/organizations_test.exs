defmodule Paperhub.OrganizationsTest do
  alias Paperhub.Accounts.User
  use Paperhub.DataCase

  alias Paperhub.Organizations
  import Paperhub.AccountsFixtures

  describe "teams" do
    alias Paperhub.Organizations.Team
    import Paperhub.OrganizationsFixtures

    @invalid_attrs %{name: ""}

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Organizations.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Organizations.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      user = user_fixture()
      valid_attrs = %{name: "some name"}

      assert {:ok, %Team{} = team} = Organizations.create_team(valid_attrs, user)
      assert team.name == "some name"
    end

    test "create_team/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Organizations.create_team(@invalid_attrs, user)
    end

    test "create_team/1 with no existing owner returns error changeset" do
      valid_attrs = %{name: "some name"}

      assert {:error, %Ecto.Changeset{} = changeset} =
               Organizations.create_team(valid_attrs, %User{id: 1000})

      assert errors_on(changeset) == %{owner_id: ["does not exist"]}
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Team{} = team} = Organizations.update_team(team, update_attrs)
      assert team.name == "some updated name"
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Organizations.update_team(team, @invalid_attrs)
      assert team == Organizations.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Organizations.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Organizations.change_team(team)
    end
  end
end
