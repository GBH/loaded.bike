defmodule LoadedBike.ModelCase do

  use ExUnit.CaseTemplate

  using do
    quote do
      alias LoadedBike.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import LoadedBike.ModelCase
      import LoadedBike.TestFactory
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(LoadedBike.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(LoadedBike.Repo, {:shared, self()})
    end

    :ok
  end

  def errors_on(changeset) do
    Keyword.keys(changeset.errors)
  end
end
