defmodule PedalApp.Web.PhotoController do
  use PedalApp.Web, :controller

  alias PedalApp.Photo

  plug :load_tour, "tour_id"
  plug :load_waypoint, "waypoint_id"
  plug :load_photo            when action in [:edit, :update, :delete]
  plug :scrub_params, "photo" when action in [:create, :update]

  defp load_photo(conn, _) do
    %{"id" => id} = conn.params
    photo = Repo.get!(assoc(conn.assigns.waypoint, :photos), id)
    dom_id = Photo.dom_id(photo)
    url = current_user_tour_waypoint_path(conn, :show, conn.assigns.tour, conn.assigns.waypoint) <> "##{dom_id}"
    conn
    |> add_breadcrumb(name: "Photo", url: url)
    |> assign(:photo, photo)
  end

  defp action(conn, _) do
    attrs = if conn.assigns[:photo] do
      [conn, conn.params, conn.assigns.tour, conn.assigns.waypoint, conn.assigns.photo]
    else
      [conn, conn.params, conn.assigns.tour, conn.assigns.waypoint]
    end
    apply(__MODULE__, action_name(conn), attrs)
  end

  # -- Actions -----------------------------------------------------------------
  def new(conn, _, tour, waypoint) do
    changeset = Photo.changeset(%Photo{})
    conn
    |> add_breadcrumb(name: "New Photo")
    |> render("new.html", tour: tour, waypoint: waypoint, changeset: changeset)
  end

  def create(conn, %{"photo" => photo_params}, tour, waypoint) do
    changeset = Photo.changeset(build_assoc(waypoint, :photos), photo_params)

    case Repo.insert(changeset) do
      {:ok, photo} ->
        dom_id = Photo.dom_id(photo)
        conn
        |> put_flash(:info, "Photo created")
        |> redirect(to: current_user_tour_waypoint_path(conn, :show, tour, waypoint) <> "##{dom_id}")
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to create Photo")
        |> add_breadcrumb(name: "New Photo")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, _params, tour, waypoint, photo) do
    changeset = Photo.changeset(photo)
    conn
    |> add_breadcrumb(name: "Edit")
    |> render("edit.html", tour: tour, waypoint: waypoint, photo: photo, changeset: changeset)
  end

  def update(conn, %{"photo" => photo_params}, tour, waypoint, photo) do
    changeset = Photo.changeset(photo, photo_params)

    case Repo.update(changeset) do
      {:ok, photo} ->
        dom_id = Photo.dom_id(photo)
        conn
        |> put_flash(:info, "Photo updated")
        |> redirect(to: current_user_tour_waypoint_path(conn, :show, tour, waypoint) <> "##{dom_id}")
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to update Photo")
        |> add_breadcrumb(name: "Edit")
        |> render("edit.html", tour: tour, waypoint: waypoint, photo: photo, changeset: changeset)
    end
  end

  def delete(conn, _params, tour, waypoint, photo) do
    Photo.delete!(photo)

    conn
    |> put_flash(:info, "Photo deleted")
    |> redirect(to: current_user_tour_waypoint_path(conn, :show, tour, waypoint) <> "#photos")
  end
end
