defmodule LoadedBike.Web.SessionController do
  use LoadedBike.Web, :controller

  plug :scrub_params, "session" when action in ~w(create)a

  def new(conn, _) do
    conn
    |> render("new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do

    case LoadedBike.Auth.login_by_email_and_pass(conn, email, password) do
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
    |> LoadedBike.Auth.logout
    |> put_flash(:info, "Logged out")
    |> redirect(to: landing_path(conn, :show))
  end
end