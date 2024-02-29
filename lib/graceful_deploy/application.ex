defmodule GracefulDeploy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GracefulDeployWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:graceful_deploy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GracefulDeploy.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: GracefulDeploy.Finch},
      # Start a worker by calling: GracefulDeploy.Worker.start_link(arg)
      # {GracefulDeploy.Worker, arg},
      # Start to serve requests, typically the last entry
      GracefulDeployWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GracefulDeploy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GracefulDeployWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
