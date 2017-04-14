defmodule LoadedBike.Web.UserController do
  use LoadedBike.Web, :controller

  alias LoadedBike.{User, Tour, Waypoint}

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => params}) do
    changeset = %User{} |> User.registration_changeset(params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> LoadedBike.Auth.login(user)
        |> put_flash(:info, "#{user.name} created")
        |> redirect(to: user_path(conn, :show, user))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    waypoints_query = Waypoint.published(Waypoint)

    tours_query = Tour
      |> Tour.published
      |> preload(waypoints: ^waypoints_query)

    user = User
      |> preload(tours: ^tours_query)
      |> Repo.get!(id)

    conn
    |> render("show.html", user: user)
  end
end