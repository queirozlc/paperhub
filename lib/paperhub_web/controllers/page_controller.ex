defmodule PaperhubWeb.PageController do
  use PaperhubWeb, :controller

  def index(conn, _params) do
    conn
    |> assign_prop(:projects, [])
    |> assign_prop(:user, conn.assigns.current_user)
    |> render_inertia("Home")
  end
end
