defmodule LoadedBike.Web.PasswordController do
  use LoadedBike.Web, :controller

  alias LoadedBike.{User, Mailer, Email}

  plug :load_user_from_email when action in [:create]
  plug :load_user_from_token when action in [:edit, :update]

  defp load_user_from_email(nil), do: nil
  defp load_user_from_email(email) do
    Repo.get_by(User, email: email)
  end
  defp load_user_from_email(conn, _) do
    case load_user_from_email(get_in(conn.params, ["password", "email"])) do
      nil ->
        conn
        |> put_flash(:error, "No account found with this email")
        |> render("new.html")
        |> halt
      user ->
        assign(conn, :user, user)
    end
  end

  defp load_user_from_token(nil),  do: nil
  defp load_user_from_token(token) do
    Repo.get_by(User, password_reset_token: token)
  end
  defp load_user_from_token(conn, _) do
    case load_user_from_token(conn.params["token"]) do
      nil ->
        conn
        |> put_flash(:error, "Invalid password reset token")
        |> redirect(to: password_path(conn, :new))
        |> halt
      user ->
        assign(conn, :user, user)
    end
  end

  # -- Actions -----------------------------------------------------------------
  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, _) do
    user = conn.assigns.user
      |> User.generate_password_reset_token!

    Email.password_reset(user) |> Mailer.deliver_later()

    conn
    |> put_flash(:info, "Password reset email is sent")
    |> redirect(to: landing_path(conn, :show))
  end

  def edit(conn, _params) do
    conn
    |> render("edit.html", user: conn.assigns.user)
  end

  def update(conn, %{"password" => %{"password" => password}}) do
    user = conn.assigns.user
    case User.change_password!(user, password) do

      {:ok, user} ->
        conn
        |> LoadedBike.Web.Auth.login(user)
        |> put_flash(:info, "Password successfully changed")
        |> redirect(to: landing_path(conn, :show))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Invalid password")
        |> render("edit.html")
    end
  end
end
