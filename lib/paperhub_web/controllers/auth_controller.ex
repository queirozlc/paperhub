defmodule PaperhubWeb.AuthController do
  require Phoenix.Router
  use PaperhubWeb, :controller
  use AshAuthentication.Phoenix.Controller
  alias AshAuthentication.{Info, Strategy}
  alias Paperhub.Accounts.User

  def new(conn, _params) do
    render_inertia(conn, "Login")
  end

  def magic_link_request(conn, user_params) do
    strategy = Info.strategy!(User, :magic_link)

    case Strategy.action(strategy, :request, user_params) do
      :ok ->
        redirect(conn, to: ~p"/login")

      {:error, _} ->
        conn
        |> put_flash(:error, "Failed to send magic link")
        |> redirect(to: ~p"/login")
    end
  end

  def success(conn, _activity, user, _token) do
    return_to = get_session(conn, :return_to) || ~p"/"

    conn
    |> delete_session(:return_to)
    |> store_in_session(user)
    |> assign(:current_user, user)
    |> redirect(to: return_to)
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
