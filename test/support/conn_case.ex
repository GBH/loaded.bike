defmodule PedalApp.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias PedalApp.Repo
      alias PedalApp.{User}
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import PedalApp.Router.Helpers
      import PedalApp.TestFactory
      import unquote(__MODULE__)

      # The default endpoint for testing
      @endpoint PedalApp.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PedalApp.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(PedalApp.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  # checking what template are we rendering here
  def assert_template(conn, template_name) do
    assert conn.private.phoenix_template == template_name
  end

  # fetching assigns data from the connection. Will flunk if assign isn't found
  def assigns(conn, name) do
    case conn.assigns[name] do
      nil ->
        flunk "Cannot find :#{name} in assigns"
      data ->
        data
    end
  end
end
