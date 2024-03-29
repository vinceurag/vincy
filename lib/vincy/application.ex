defmodule Vincy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Vincy.Repo,
      # Start the Telemetry supervisor
      VincyWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Vincy.PubSub},
      # Start the Endpoint (http/https)
      VincyWeb.Endpoint,
      # Start a worker by calling: Vincy.Worker.start_link(arg)
      # {Vincy.Worker, arg}
      {Redix, name: :redix}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Vincy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    VincyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
