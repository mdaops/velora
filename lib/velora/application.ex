defmodule Velora.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      VeloraWeb.Telemetry,
      # Start the Ecto repository
      Velora.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Velora.PubSub},
      # Start Finch
      {Finch, name: Velora.Finch},
      # Start the Endpoint (http/https)
      VeloraWeb.Endpoint
      # Start a worker by calling: Velora.Worker.start_link(arg)
      # {Velora.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Velora.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VeloraWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
