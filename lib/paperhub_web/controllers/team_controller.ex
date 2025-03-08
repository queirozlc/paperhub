defmodule PaperhubWeb.TeamController do
  use PaperhubWeb, :controller
  alias Paperhub.Organizations

  def create(conn, params) do
    user = conn.assigns[:current_user]

    with {:ok, %{user: _user, team: team}} <-
           Organizations.create_team(params, user, default_team?: true) do
      Paperhub.Repo.put_team_id(team.id)

      conn
      |> put_flash(:info, "Team created successfully.")
      |> redirect(to: ~p"/")
    else
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
