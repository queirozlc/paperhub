defmodule PaperhubWeb.UserAuth do
  use PaperhubWeb, :verified_routes

  import Plug.Conn
  import Phoenix.Controller
  import AshAuthentication.Phoenix.Plug

  def log_in_user(conn, user) do
    return_to = get_session(conn, :return_to)

    conn
    |> renew_session()
    |> store_in_session(user)
    |> assign(:current_user, user)
    |> redirect(to: redirect_path(conn, user, return_to))
  end

  defp redirect_path(conn, user, nil) do
    if user.current_team_id == nil do
      ~p"/onboarding"
    else
      signed_in_path(conn)
    end
  end

  defp redirect_path(_conn, user, path) do
    if user.current_team_id == nil, do: ~p"/onboarding", else: path
  end

  # This function renews the session ID and erases the whole
  # session to avoid fixation attacks. If there is any data
  # in the session you may want to preserve after log in/log out,
  # you must explicitly fetch the session data before clearing
  # and then immediately set it after clearing, for example:
  #
  #     defp renew_session(conn) do
  #       preferred_locale = get_session(conn, :preferred_locale)
  #
  #       conn
  #       |> configure_session(renew: true)
  #       |> clear_session()
  #       |> put_session(:preferred_locale, preferred_locale)
  #     end
  #
  defp renew_session(conn) do
    delete_csrf_token()

    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  @doc """
  Redirects users to complete their onboarding if they haven't yet.
  This is useful in case of users trying to access the application through url
  """
  def redirect_if_onboarding_not_completed(conn, _opts) do
    if conn.assigns[:current_user].current_team_id == nil do
      conn
      |> redirect(to: ~p"/onboarding")
      |> halt()
    else
      conn
    end
  end

  @doc """
  Does not allow users to access the onboarding page if they have already completed it.
  """
  def redirect_if_onboarding_is_completed(conn, _opts) do
    if conn.assigns[:current_user].current_team_id != nil do
      conn
      |> redirect(to: ~p"/")
      |> halt()
    else
      conn
    end
  end

  @doc """
  Used for routes that require the user to not be authenticated.
  """
  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  @doc """
  Used for routes that require the user to be authenticated.
  If you want to enforce the user email is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> maybe_store_return_to()
      |> redirect(to: ~p"/login")
      |> halt()
    end
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    put_session(conn, :user_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn

  defp signed_in_path(_conn), do: ~p"/"
end
