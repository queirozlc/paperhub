defmodule PaperhubWeb.TeamController do
  alias Paperhub.Accounts
  use PaperhubWeb, :controller

  def create_default(conn, team_params) do
    case Accounts.create_default_team(team_params, actor: conn.assigns.current_user) do
      {:ok, _team} ->
        redirect(conn, to: ~p"/")

      {:error, changeset} ->
        dbg(changeset)

        conn
        |> assign_errors(changeset)
        |> redirect(to: ~p"/onboarding")
    end
  end
end
