defmodule PaperhubWeb.AuthController do
  require Phoenix.Router
  use PaperhubWeb, :controller
  use AshAuthentication.Phoenix.Controller
  alias PaperhubWeb.UserAuth
  alias AshAuthentication.{Info, Strategy}
  alias Paperhub.Accounts.User

  def new(conn, _params) do
    render_inertia(conn, "Login")
  end

  def magic_link_request(conn, %{"email" => email} = user_params) do
    strategy = Info.strategy!(User, :magic_link)

    case Strategy.action(strategy, :request, user_params) do
      :ok ->
        conn
        |> redirect(to: ~p"/verify_email/#{email}")

      {:error, _} ->
        conn
        |> put_flash(:error, "Failed to send magic link")
        |> redirect(to: ~p"/login")
    end
  end

  def verify_email(conn, %{"email" => email}) do
    if email == nil do
      redirect(conn, to: ~p"/login")
    else
      conn
      |> assign_prop(:email, email)
      |> render_inertia("VerifyEmail")
    end
  end

  def success(conn, _activity, user, _token) do
    UserAuth.log_in_user(conn, user)
  end

  def failure(conn, _activity, _reason) do
    conn
    |> redirect(to: ~p"/login")
  end

  def sign_out(conn, _params) do
    return_to = get_session(conn, :return_to) || ~p"/"

    conn
    |> clear_session()
    |> put_flash(:info, "You are now signed out")
    |> redirect(to: return_to)
  end
end
