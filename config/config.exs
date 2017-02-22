# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :pedal_app,
  ecto_repos: [PedalApp.Repo]

# Configures the endpoint
config :pedal_app, PedalApp.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/A/ThS5sAqrDfxkKO8WQCRpHxbf09KM3zwGQZ917Adaqss5SLowezF+Xegrt3HJz",
  render_errors: [view: PedalApp.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PedalApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :template_engines,
  haml: PhoenixHaml.Engine

config :guardian, Guardian,
  issuer: "PedalApp.#{Mix.env}",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: PedalApp.GuardianSerializer,
  secret_key: to_string(Mix.env) <> "to_be_replaced_with_env_key_later"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
