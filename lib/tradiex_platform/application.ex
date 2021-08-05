defmodule TradiexPlatform.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TradiexPlatformWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TradiexPlatform.PubSub},
      # Start the Endpoint (http/https)
      TradiexPlatformWeb.Endpoint,
      {TradiexPlatform.Cache, []}
      # Start a worker by calling: TradiexPlatform.Worker.start_link(arg)
      # {TradiexPlatform.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TradiexPlatform.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TradiexPlatformWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
