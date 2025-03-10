defmodule Paperhub.Accounts.Team.Changes.SetOwnerCurrentTeam do
  use Ash.Resource.Change

  alias Ash.Changeset
  alias Paperhub.Accounts

  def change(changeset, _opts, _context) do
    Changeset.after_transaction(changeset, &set_owner_current_team/2)
  end

  defp set_owner_current_team(_changeset, {:ok, team}) do
    case Accounts.set_current_team(team.owner, team.id, actor: team.owner) do
      {:ok, _user} -> {:ok, team}
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp set_owner_current_team(_changeset, {:error, changeset}) do
    {:error, changeset}
  end
end
