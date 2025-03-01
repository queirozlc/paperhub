defmodule PaperhubWeb.AuthController do
  use PaperhubWeb, :controller

  def new(conn, _params) do
    render_inertia(conn, "Login")
  end

  def verify_email(conn, params) do
    email = Map.get(params, "email")

    if email == nil do
      redirect(conn, to: ~p"/login")
    else
      conn
      |> assign_prop(:email, email)
      |> render_inertia("VerifyEmail")
    end
  end

  def magic_link_request(conn, user_params) do
  end
end
