defmodule Pedal.SessionController do
  use Pedal.Web, :controller

  plug :scrub_params, "session" when action in ~w(create)a

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Pedal.Rider

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do

    rider = Repo.get_by(Rider, email: email)

    result = cond do
      rider && checkpw(password, rider.password_hash) ->
        {:ok, login(conn, rider)}

      rider ->
        {:error, :unauthorized, conn}

      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end

    case result do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome")
        |> redirect(to: rider_path(conn, :show, rider))

      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid login credentials")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    # todo
  end

  defp login(conn, rider) do
    Guardian.Plug.sign_in(conn, rider)
  end
end