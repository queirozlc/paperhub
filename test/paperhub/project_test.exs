defmodule Paperhub.ProjectTest do
  alias Paperhub.{Projects, Projects.Project}
  use Paperhub.DataCase, async: true
  import ExUnitProperties

  describe "valid inputs" do
    setup do
      owner = build_user!()
      {:ok, owner: owner}
    end

    property "accepts all valid inputs", %{owner: owner} do
      check all(input <- Ash.Generator.action_input(Project, :create)) do
        assert Projects.changeset_to_create_project(input, actor: owner).valid?
      end
    end

    property "succeds on all valid inputs", %{owner: owner} do
      check all(input <- Ash.Generator.action_input(Project, :create)) do
        Projects.create_project!(input, authorize?: false, actor: owner)
      end
    end

    property "rejects invalid inputs" do
      check all(input <- Ash.Generator.action_input(Project, :create)) do
        refute Projects.changeset_to_create_project(input).valid?
      end
    end
  end

  describe "authorization" do
    setup do
      owner = build_user!()
      {:ok, owner: owner}
    end

    test "allows user to create a project as an owner", %{owner: owner} do
      assert Projects.can_create_project?(owner)
    end
  end

  describe "calculations" do
    test "hash project id" do
      project = Projects.create_project!(actor: build_user!())

      sqids = Sqids.new!(min_length: 21)

      assert Ash.calculate!(project, :hash_id) == Sqids.encode!(sqids, List.wrap(project.id))
    end
  end
end
