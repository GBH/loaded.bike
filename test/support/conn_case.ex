defmodule LoadedBike.Web.ConnCase do
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

      alias LoadedBike.Repo
      alias LoadedBike.{User}
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import LoadedBike.Web.Router.Helpers
      import LoadedBike.TestFactory
      import unquote(__MODULE__)

      # The default endpoint for testing
      @endpoint LoadedBike.Web.Endpoint

      # guardian login
      def login(user = %User{}, token \\ :token, opts \\ []) do
        Plug.Test.init_test_session(build_conn(), %{})
        |> Guardian.Plug.sign_in(user, token, opts)
      end

      # checking what template are we rendering here
      def template(conn) do
        conn.private.phoenix_template
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
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(LoadedBike.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(LoadedBike.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
