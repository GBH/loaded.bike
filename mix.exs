defmodule LoadedBike.Mixfile do
  use Mix.Project

  def project do
    [app: :loaded_bike,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {LoadedBike, []},
     applications: [
      :phoenix,
      :phoenix_pubsub,
      :phoenix_html,
      :cowboy,
      :logger,
      :gettext,
      :phoenix_ecto,
      :postgrex,
      :comeonin,
      :arc,
      :arc_ecto,
      :breadcrumble,
      :earmark,
      :guardian,
      :html_sanitize_ex,
      :kerosene,
      :mochiweb,
      :phoenix_haml,
      :elixir_make,
      :edeliver,
      :rollbax,
      :sweet_xml,
      :ecto_enum,
      :secure_random,
      :bamboo
    ]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/factories"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix,              "~> 1.3.0-rc", override: true},
      {:phoenix_pubsub,       "~> 1.0"},
      {:phoenix_ecto,         "~> 3.0"},
      {:postgrex,             ">= 0.0.0"},
      {:gettext,              "~> 0.11"},
      {:cowboy,               "~> 1.0"},

      {:phoenix_haml,         "~> 0.2.3"},
      {:comeonin,             "~> 3.0"},
      {:guardian,             "~> 0.14"},
      {:arc,                  "~> 0.7.0", override: true},
      {:arc_ecto,             "~> 0.5.0"},
      {:earmark,              "~> 1.2.0"},
      {:html_sanitize_ex,     "~> 1.1.0"},
      {:breadcrumble,         "~> 1.0.0"},
      {:kerosene,             "~> 0.6.1"},
      {:mochiweb,             "~> 2.15.0", override: true}, #dependency hell
      {:edeliver,             "~> 1.4.2"},
      {:distillery,           "~> 1.0"},
      {:rollbax,              "~> 0.6"},
      {:sweet_xml,            "~> 0.6.5"},
      {:ecto_enum,            "~> 1.0"},
      {:secure_random,        "~> 0.5"},
      {:bamboo,               "~> 0.8"},

      # -- dev -----------------------------------------------------------------
      {:phoenix_live_reload,  "~> 1.0", only: :dev},

      # -- test ----------------------------------------------------------------
      {:ex_machina,           "~> 1.0", only: :test},
      {:floki,                "~> 0.14.0", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
