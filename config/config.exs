# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :loaded_bike,
  ecto_repos: [LoadedBike.Repo]

# Configures the endpoint
config :loaded_bike, LoadedBike.Web.Endpoint,
  url:              [host: "localhost"],
  secret_key_base:  "/A/ThS5sAqrDfxkKO8WQCRpHxbf09KM3zwGQZ917Adaqss5SLowezF+Xegrt3HJz",
  render_errors:    [view: LoadedBike.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [
    name: LoadedBike.PubSub,
    adapter: Phoenix.PubSub.PG2
  ]

# Configures Elixir's Logger
config :logger, :console,
  format:   "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :drab,
  main_phoenix_app: :loaded_bike

config :phoenix, :template_engines,
  haml: PhoenixHaml.Engine,
  drab: Drab.Live.Engine

config :guardian, Guardian,
  issuer:         "LoadedBike.#{Mix.env}",
  ttl:            {30, :days},
  verify_issuer:  true,
  serializer:     LoadedBike.Web.Auth.GuardianSerializer,
  secret_key:     to_string(Mix.env) <> "to_be_replaced_with_env_key_later"

config :kerosene, theme: :bootstrap4

config :rollbax,
  access_token: "placeholder",
  environment:  Mix.env(),
  enabled:      false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
