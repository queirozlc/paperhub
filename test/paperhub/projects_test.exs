defmodule Paperhub.ProjectsTest do
  use Paperhub.DataCase

  alias Paperhub.Projects

  describe "projects" do
    alias Paperhub.{Organizations.Team, Projects, Projects.Project}
    import Paperhub.ProjectsFixtures
    import Paperhub.OrganizationsFixtures, only: [team_fixture: 0]

    @invalid_attrs %{description: nil, title: nil, visibility: nil}

    setup do
      team = team_fixture()
      Repo.put_team_id(team.id)
      %{team: team}
    end

    test "list_projects/0 returns all projects", %{team: team} do
      project = project_fixture(team)
      assert Projects.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id", %{team: team} do
      project = project_fixture(team)
      assert Projects.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project", %{team: team} do
      valid_attrs = %{
        description: "some description",
        title: "some title",
        visibility: :public
      }

      assert {:ok, %Project{} = project} = Projects.create_project(valid_attrs, team)
      assert project.description == "some description"
      assert project.title == "some title"
      assert project.visibility == :public
    end

    test "create_project/1 with invalid data returns error changeset", %{team: team} do
      assert {:error, %Ecto.Changeset{}} = Projects.create_project(@invalid_attrs, team)
    end

    test "create_project/1 with invalid team returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} =
               Projects.create_project(%{}, %Team{})

      assert errors_on(changeset) == %{team_id: ["can't be blank"]}
    end

    test "create_project/1 with no existing team returns error changeset" do
      valid_attrs = %{
        description: "some description",
        title: "some title",
        visibility: :public
      }

      assert {:error, %Ecto.Changeset{} = changeset} =
               Projects.create_project(valid_attrs, %Team{id: 1000})

      assert errors_on(changeset) == %{team_id: ["does not exist"]}
    end

    test "update_project/2 with valid data updates the project", %{team: team} do
      project = project_fixture(team)

      update_attrs = %{
        description: "some updated description",
        title: "some updated title",
        visibility: :private
      }

      assert {:ok, %Project{} = project} = Projects.update_project(project, update_attrs)
      assert project.description == "some updated description"
      assert project.title == "some updated title"
      assert project.visibility == :private
    end

    test "update_project/2 with invalid data returns error changeset", %{team: team} do
      project = project_fixture(team)
      assert {:error, %Ecto.Changeset{}} = Projects.update_project(project, @invalid_attrs)
      assert project == Projects.get_project!(project.id)
    end

    test "delete_project/1 deletes the project", %{team: team} do
      project = project_fixture(team)
      assert {:ok, %Project{}} = Projects.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset", %{team: team} do
      project = project_fixture(team)
      assert %Ecto.Changeset{} = Projects.change_project(project)
    end
  end
end
