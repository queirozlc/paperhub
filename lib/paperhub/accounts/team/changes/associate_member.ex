defmodule Paperhub.Accounts.Team.Changes.AssociateMember do
  use Ash.Resource.Change

  alias Paperhub.Accounts
  alias Ash.Changeset

  @impl true
  def change(changeset, _opts, _context) do
    Changeset.after_action(changeset, &associate_member/2)
  end

  defp associate_member(_changeset, team) do
    params = %{member_id: team.owner_id, team_id: team.id, role: :admin}

    case Accounts.create_membership(params) do
      {:ok, _membership} -> {:ok, team}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
