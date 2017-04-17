defmodule LoadedBike.Web.Auth.GuardianErrorHandler do
  import LoadedBike.Web.Router.Helpers

  def unauthenticated(conn, _params) do
    conn
    |> Phoenix.Controller.put_flash(:error, "You must be signed in to access")
    |> Phoenix.Controller.redirect(to: session_path(conn, :new))
  end
end