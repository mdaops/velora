import Config

config :velora,
  ecto_repos: [Velora.Repo]

# Configures the endpoint
config :velora, VeloraWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: VeloraWeb.ErrorHTML, json: VeloraWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Velora.PubSub,
  live_view: [signing_salt: "srr0KOcd"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :velora, Velora.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.2.4",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :velora, :github_app_manifest,
  name: "Velora",
  description: "Velora GitHub App",
  public: false,
  hook_path: "/api/github/webhook",
  redirect_path: "/github/app/manifest/callback",
  setup_url: "",
  default_events: ["push"],
  default_permissions: %{
    "contents" => "read",
    "metadata" => "read"
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
