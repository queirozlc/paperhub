defmodule Paperhub.Accounts.User.Checks.CanSetAsCurrentTeam do
  alias Ash.Changeset
  alias Paperhub.Accounts
  use Ash.Policy.SimpleCheck

  def describe(_opts), do: "user is a member of the team being set as current"

  def match?(actor, %Ash.Policy.Authorizer{changeset: changeset}, _options) do
    team_id = Changeset.get_argument(changeset, :team_id)
    {:ok, can?} = Accounts.team_member?(actor.id, team_id)
    can?
  end
end
