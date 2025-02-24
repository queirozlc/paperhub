defmodule PaperhubWeb.ProjectController do
  use PaperhubWeb, :controller
  alias Paperhub.Projects

  def create(conn, _params) do
    case Projects.create_project(actor: conn.assigns[:current_user]) do
      {:ok, project} ->
        conn
        |> assign(:project_id, project.id)
        |> assign_prop(:project, project)
        |> redirect(to: ~p"/workspace/#{project.hash_id}")

      {:error, changeset} ->
        # TODO: Handle the error properly
        conn |> assign_errors(changeset) |> halt()
    end
  end

  def show(conn, %{"public_id" => public_id}) do
    sqids = Sqids.new!(min_length: 21)
    [id] = Sqids.decode!(sqids, public_id)

    project = Ash.get!(Projects.Project, id: id)

    conn
    |> assign_prop(:project, project)
    |> render_inertia("Editor")
  end
end
