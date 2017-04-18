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
        |> LoadedBike.Web.Auth.login(user)
        |> put_flash(:info, "Account created")
        |> redirect(to: landing_path(conn, :show))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to create Account")
        |> render("new.html", changeset: changeset)
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
    |> add_breadcrumb(name: "#{user.name} tours")
    |> render("show.html", user: user)
  end

  def edit(conn, _) do
    changeset = User.changeset(conn.assigns.current_user)

    conn
    |> render("edit.html", changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    changeset = User.changeset(conn.assigns.current_user, user_params)

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Account updated")
        |> redirect(to: current_user_tour_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to update Account")
        |> render("edit.html", changeset: changeset)
    end
  end
end
