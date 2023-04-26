defmodule BinaryMonitor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BinaryMonitorWeb.Telemetry,
      # Start the Ecto repository
      BinaryMonitor.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: BinaryMonitor.PubSub},
      # Start Finch
      {Finch, name: BinaryMonitor.Finch},
      # Start the Endpoint (http/https)
      BinaryMonitorWeb.Endpoint,
      # Start a worker by calling: BinaryMonitor.Worker.start_link(arg)
      # {BinaryMonitor.Worker, arg}
      BinaryMonitor.HandlerSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BinaryMonitor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BinaryMonitorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
