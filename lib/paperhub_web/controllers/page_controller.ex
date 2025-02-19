defmodule PaperhubWeb.PageController do
  alias Paperhub.Projects.Project
  use PaperhubWeb, :controller

  def index(conn, _params) do
    projects = Ash.read!(Project)

    conn
    |> assign_prop(:projects, projects)
    |> render_inertia("Home")
  end
end
