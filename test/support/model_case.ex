defmodule PedalApp.ModelCase do

  use ExUnit.CaseTemplate

  using do
    quote do
      alias PedalApp.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import PedalApp.ModelCase
      import PedalApp.TestFactory
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PedalApp.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(PedalApp.Repo, {:shared, self()})
    end

    :ok
  end

  def errors_on(changeset) do
    Keyword.keys(changeset.errors)
  end
end
