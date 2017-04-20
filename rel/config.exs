# Import all plugins from `rel/plugins`
# They can then be used by adding `plugin MyPlugin` to
# either an environment, or release definition, where
# `MyPlugin` is the name of the plugin module.
Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: Mix.env()

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"hOTB4mHK;6vXE]BP9/=Si>u_ca<vG1)&eSEFr@rfSop|P;&ibZ=B9y!`U5P{j*a%"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"^0EYhYiD%tz0rNfB?4%ZA1|@?!O,?j$.fH=}<d}bM92@=KMHKJvz|M<h7O`6hq3*"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :loaded_bike do
  set version: current_version(:loaded_bike)
end
