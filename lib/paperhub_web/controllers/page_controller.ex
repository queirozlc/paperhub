defmodule PaperhubWeb.PageController do
  alias Paperhub.Projects
  use PaperhubWeb, :controller

  def index(conn, _params) do
    conn
    |> assign_prop(:projects, Projects.list_projects())
    |> assign_prop(:user, conn.assigns.current_user)
    |> render_inertia("Home")
  end

  def onboarding(conn, _params) do
    conn
    |> assign_prop(:user, conn.assigns.current_user)
    |> render_inertia("Onboarding")
  end
end
