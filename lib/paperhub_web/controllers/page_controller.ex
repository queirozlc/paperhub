defmodule PaperhubWeb.PageController do
  use PaperhubWeb, :controller

  def home(conn, _params) do
    render_inertia(conn, "Home")
  end
end
