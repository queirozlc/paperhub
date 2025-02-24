defmodule PaperhubWeb.PageController do
  alias Paperhub.Projects
  use PaperhubWeb, :controller

  def index(conn, _params) do
    projects = Projects.list_projects!(actor: conn.assigns.current_user)

    conn
    |> assign_prop(:projects, projects)
    |> assign_prop(:user, conn.assigns.current_user)
    |> render_inertia("Home")
  end
end
