use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :loaded_bike, LoadedBike.Web.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../assets", __DIR__)]]

# Watch static and templates for browser reloading.
config :loaded_bike, LoadedBike.Web.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/loaded_bike/web/views/.*(ex)$},
      ~r{lib/loaded_bike/web/templates/.*(eex|haml|drab)$}
    ]
  ]

config :loaded_bike, LoadedBike.Mailer,
  adapter: Bamboo.LocalAdapter
  # adapter: Bamboo.PostageAppAdapter,
  # api_key: ""


# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :loaded_bike, LoadedBike.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "loaded_bike_dev",
  hostname: "localhost",
  pool_size: 10
