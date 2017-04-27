use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :loaded_bike, LoadedBike.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :loaded_bike, LoadedBike.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "loaded_bike_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Speeding up BCrypt things for test env
config :comeonin, :bcrypt_log_rounds, 1
