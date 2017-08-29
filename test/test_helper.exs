ExUnit.configure(exclude: [skip: true])
ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(LoadedBike.Repo, :manual)

{:ok, _} = Application.ensure_all_started(:ex_machina)

