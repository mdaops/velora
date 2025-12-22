defmodule VeloraWeb.Router do
  use VeloraWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {VeloraWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VeloraWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/github/connect", GithubInstallController, :new

    get "/github/app/manifest", GithubAppManifestController, :new
    get "/github/app/manifest/callback", GithubAppManifestController, :callback
  end

  scope "/api", VeloraWeb do
    pipe_through :api

    post "/github/events", API.GithubWebhook, :create
    post "/github/webhook", API.GithubWebhook, :create

    get "/github/connect/callback", GithubInstallController, :callback
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:velora, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: VeloraWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
