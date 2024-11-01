defmodule ExPoller.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ExPollerWeb.Telemetry,
      ExPoller.Repo,
      {DNSCluster, query: Application.get_env(:ex_poller, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ExPoller.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ExPoller.Finch},
      # Start a worker by calling: ExPoller.Worker.start_link(arg)
      # {ExPoller.Worker, arg},
      # Start to serve requests, typically the last entry
      ExPollerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExPoller.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExPollerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
