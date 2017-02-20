defmodule Pedal.SessionController do
  use Pedal.Web, :controller

  plug :scrub_params, "session" when action in ~w(create)a

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Pedal.User

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do

    user = Repo.get_by(User, email: email)

    result = cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, login(conn, user)}

      user ->
        {:error, :unauthorized, conn}

      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end

    case result do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome")
        |> redirect(to: user_path(conn, :show, user))

      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid login credentials")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    # todo
  end

  defp login(conn, user) do
    Guardian.Plug.sign_in(conn, user)
  end
end