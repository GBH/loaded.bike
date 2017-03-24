defmodule PedalApp.Web.PhotoController do
  use PedalApp.Web, :controller

  alias PedalApp.Photo

  plug :scrub_params, "photo" when action in [:create, :update]
  plug :load_tour
  plug :load_waypoint
  plug :load_photo when action in [:edit, :update, :delete]

  defp load_tour(conn, _) do
    %{"tour_id" => tour_id} = conn.params
    tour = Repo.get!(assoc(conn.assigns.current_user, :tours), tour_id)
    assign(conn, :tour, tour)
  end

  defp load_waypoint(conn, _) do
    %{"waypoint_id" => waypoint_id} = conn.params
    waypoint = Repo.get!(assoc(conn.assigns.tour, :waypoints), waypoint_id)
    assign(conn, :waypoint, waypoint)
  end

  defp load_photo(conn, _) do
    %{"id" => id} = conn.params
    photo = Repo.get!(assoc(conn.assigns.waypoint, :photos), id)
    assign(conn, :photo, photo)
  end

  defp action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.tour, conn.assigns.waypoint]
    )
  end

  # -- Actions -----------------------------------------------------------------
  def new(conn, _, tour, waypoint) do
    changeset = Photo.changeset(%Photo{})
    render conn, "new.html", tour: tour, waypoint: waypoint, changeset: changeset
  end

  def create(conn, %{"photo" => photo_params}, tour, waypoint) do
    changeset = Photo.changeset(build_assoc(waypoint, :photos), photo_params)

    case Repo.insert(changeset) do
      {:ok, _photo} ->
        conn
        |> put_flash(:info, "Photo created")
        |> redirect(to: current_user_tour_waypoint_path(conn, :show, tour, waypoint))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to create Photo")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => _id}, tour, waypoint) do
    photo = conn.assigns.photo
    changeset = Photo.changeset(photo)
    render conn, "edit.html", tour: tour, waypoint: waypoint, photo: photo, changeset: changeset
  end

  def update(conn, %{"id" => _id, "photo" => photo_params}, tour, waypoint) do
    photo = conn.assigns.photo
    changeset = Photo.changeset(photo, photo_params)

    case Repo.update(changeset) do
      {:ok, _photo} ->
        conn
        |> put_flash(:info, "Photo updated")
        |> redirect(to: current_user_tour_waypoint_path(conn, :show, tour, waypoint))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to update Photo")
        |> render("edit.html", tour: tour, waypoint: waypoint, photo: photo, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => _id}, tour, waypoint) do
    Photo.delete!(conn.assigns.photo)

    conn
    |> put_flash(:info, "Photo deleted")
    |> redirect(to: current_user_tour_waypoint_path(conn, :show, tour, waypoint))
  end
end
