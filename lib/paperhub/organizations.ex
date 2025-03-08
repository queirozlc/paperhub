defmodule Paperhub.Organizations do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias Paperhub.Organizations.Membership
  alias Paperhub.Accounts
  alias Paperhub.Accounts.User
  alias Paperhub.Organizations.Team
  alias Paperhub.Repo

  @doc """
  Returns the list of teams for the given owner.

  ## Examples

      iex> list_teams(123)
      [%Team{}, ...]

      iex> list_teams(456)
      []
  """
  def list_teams(owner_id) do
    from(t in Team, where: t.owner_id == ^owner_id)
    |> Repo.all(skip_team_id: true)
  end

  @doc """
  Gets a single team by ID and owner ID.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123, 1)
      %Team{}

      iex> get_team!(456, 1)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id, owner_id) do
    from(
      t in Team,
      where: t.id == ^id and t.owner_id == ^owner_id,
      select: t
    )
    |> Repo.one!(skip_team_id: true)
  end

  @doc """
  Creates a team for the given owner. This also updates a

  ## Examples

      iex> create_team(%{field: value}, owner)
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value}, owner)
      {:error, %Ecto.Changeset{}}

      iex> create_team(%{field: value}, nil)
      {:error, %Ecto.Changeset{}}

  ## Options

  * `:default_team` - If true, the team will be set as the user's current team and update the user name. (default: false)
  """
  def create_team(params, user, opts \\ []) do
    default_team? = Keyword.get(opts, :default_team?, false)

    Repo.transaction(new_team_multi(user, params, default_team?))
  end

  defp new_team_multi(%User{} = user, params, default_team?) do
    membership_params = %{role: :admin}

    if default_team? do
      Ecto.Multi.new()
      |> insert_team(user, params)
      |> insert_membership(user, membership_params)
      |> set_current_user_team(user, params)
    else
      Ecto.Multi.new()
      |> insert_team(user, params)
      |> insert_membership(user, membership_params)
    end
  end

  defp insert_membership(multi, user, membership_params) do
    Ecto.Multi.insert(multi, :membership, fn %{team: team} ->
      change_membership(%Membership{team_id: team.id, member_id: user.id}, membership_params)
    end)
  end

  defp set_current_user_team(multi, user, params) do
    Ecto.Multi.update(
      multi,
      :user,
      fn %{team: team} ->
        user = Repo.preload(user, :current_team)
        Accounts.onboarding_change(user, team, params)
      end
    )
  end

  defp insert_team(multi, user, team_params) do
    Ecto.Multi.insert(multi, :team, change_team(%Team{owner_id: user.id}, team_params))
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team, skip_team_id: true)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  ## Membership
  ### Do not make sense to use the defaults for the member, i'll create the member functions later

  defp change_membership(%Membership{} = membership, attrs) do
    Membership.changeset(membership, attrs)
  end
end
