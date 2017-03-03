defmodule PedalApp.Auth do

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias PedalApp.{User, Repo}

  def login_by_email_and_pass(conn, email, pass) do
    user = Repo.get_by(User, email: email)

    cond do
      user && checkpw(pass, user.password_hash) ->
        {:ok, login(conn, user)}

      user ->
        {:error, :unauthorized, conn}

      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def login(conn, user) do
    Guardian.Plug.sign_in(conn, user)
  end

  def logout(conn) do
    Guardian.Plug.sign_out(conn)
  end
end