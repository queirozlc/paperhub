defmodule PaperhubWeb.UserSessionController do
  use PaperhubWeb, :controller

  alias Paperhub.Accounts
  alias PaperhubWeb.UserAuth

  def new(conn, _params) do
    render_inertia(conn, "Login")
  end

  def magic_link_request(conn, %{"email" => email} = user_params) do
    with {:ok, user} <- Accounts.get_or_register_user(user_params),
         {:ok, _} <-
           Accounts.deliver_magic_link_token(user, &url(~p"/magic_link/sign_in/#{&1}")) do
      redirect(conn, to: ~p"/verify_email/#{email}")
    else
      {:error, changeset} ->
        conn
        |> assign_errors(changeset)
        |> render_inertia("Login")
    end
  end

  def sign_in_with_magic_link(conn, %{"token" => token}) do
    case Accounts.sign_in_magic_link(token) do
      {:ok, user} -> UserAuth.log_in_user(conn, user, %{"remember_me" => "true"})
      :error -> conn |> put_flash(:error, "Invalid token.") |> redirect(to: ~p"/login")
    end
  end

  def verify_email(conn, %{"email" => email}) do
    conn
    |> assign_prop(:email, email)
    |> render_inertia("VerifyEmail")
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
