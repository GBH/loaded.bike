defmodule LoadedBike.Web.SessionController do
  use LoadedBike.Web, :controller

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case LoadedBike.Web.Auth.login_by_email_and_pass(conn, email, password) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back")
        |> redirect(to: landing_path(conn, :show))

      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid login credentials")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> LoadedBike.Web.Auth.logout
    |> put_flash(:info, "Signed out")
    |> redirect(to: landing_path(conn, :show))
  end
end