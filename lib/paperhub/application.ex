defmodule Paperhub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PaperhubWeb.Telemetry,
      Paperhub.Repo,
      {DNSCluster, query: Application.get_env(:paperhub, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Paperhub.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Paperhub.Finch},
      # Start a worker by calling: Paperhub.Worker.start_link(arg)
      # {Paperhub.Worker, arg},
      # Start to serve requests, typically the last entry
      PaperhubWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :paperhub]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Paperhub.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PaperhubWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
