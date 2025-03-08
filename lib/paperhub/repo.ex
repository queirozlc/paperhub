defmodule Paperhub.Repo do
  use Ecto.Repo,
    otp_app: :paperhub,
    adapter: Ecto.Adapters.Postgres

  require Ecto.Query

  @tenant_key {__MODULE__, :team_id}

  @impl true
  def prepare_query(_operation, query, opts) do
    cond do
      opts[:skip_team_id] || opts[:ecto_query] in [:schema_migration, :preload] ->
        {query, opts}

      team_id = opts[:team_id] ->
        {Ecto.Query.where(query, team_id: ^team_id), opts}

      true ->
        raise "expected team_id or skip_team_id to be set"
    end
  end

  @impl true
  def default_options(_operation) do
    [team_id: get_team_id()]
  end

  def put_team_id(team_id), do: Process.put(@tenant_key, team_id)
  def get_team_id(), do: Process.get(@tenant_key)
end
