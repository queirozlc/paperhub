defmodule Paperhub.Accounts.Team.Changes.SetOwnerCurrentTeam do
  use Ash.Resource.Change

  alias Ash.Changeset
  alias Paperhub.Accounts

  def change(changeset, _opts, _context) do
    Changeset.after_action(changeset, &set_owner_current_team/2)
  end

  defp set_owner_current_team(_changeset, team) do
    Accounts.get_user!(team.owner_id)
    |> Accounts.set_current_team!(team.id, %{name: team.name})

    {:ok, team}
  end
end
