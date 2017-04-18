defmodule LoadedBike.Web.User.WaypointController do
  use LoadedBike.Web, :controller
  use LoadedBike.Web.Controller.User.Helpers

  alias LoadedBike.{Waypoint, Photo}

  plug :load_tour, "tour_id"
  plug :load_waypoint, "id"       when action in [:show, :edit, :update, :delete]
  plug :scrub_params, "waypoint"  when action in [:create, :update]

  defp action(conn, _) do
    attrs = [conn, conn.params, conn.assigns.tour]
    attrs = if conn.assigns[:waypoint], do: attrs ++ [conn.assigns.waypoint], else: attrs
    apply(__MODULE__, action_name(conn), attrs)
  end

  # -- Actions -----------------------------------------------------------------
  def show(conn, _params, tour, waypoint) do
    photos_query = Photo
      |> order_by(asc: :inserted_at)

    waypoint = Repo.preload(waypoint, photos: photos_query)

    prev_waypoint = waypoint
      |> Waypoint.previous
      |> Repo.one

    next_waypoint = waypoint
      |> Waypoint.next
      |> Repo.one

    render conn, "show.html",
      tour:           tour,
      waypoint:       waypoint,
      next_waypoint:  next_waypoint,
      prev_waypoint:  prev_waypoint
  end

  def new(conn, _, tour) do
    changeset = tour
    |> build_assoc(:waypoints)
    |> Waypoint.changeset

    conn
    |> add_breadcrumb(name: "New Waypoint")
    |> render("new.html", tour: tour, changeset: changeset)
  end

  def create(conn, %{"waypoint" => waypoint_params}, tour) do
    changeset = tour
    |> build_assoc(:waypoints)
    |> Waypoint.changeset(waypoint_params)

    case Repo.insert(changeset) do
      {:ok, waypoint} ->
        conn
        |> put_flash(:info, "Waypoint created")
        |> redirect(to: current_user_tour_waypoint_path(conn, :show, tour, waypoint))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to create Waypoint")
        |> add_breadcrumb(name: "New Waypoint")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, _params, tour, waypoint) do
    tour = %{tour | waypoints: Enum.reject(tour.waypoints, fn(w) -> w.id == waypoint.id end)}
    changeset = Waypoint.changeset(waypoint)

    conn
    |> add_breadcrumb(name: "Edit")
    |> render("edit.html", tour: tour, waypoint: waypoint, changeset: changeset)
  end

  def update(conn, %{"waypoint" => waypoint_params}, tour, waypoint) do
    changeset = Waypoint.changeset(waypoint, waypoint_params)

    case Repo.update(changeset) do
      {:ok, waypoint} ->
        conn
        |> put_flash(:info, "Waypoint updated")
        |> redirect(to: current_user_tour_waypoint_path(conn, :show, tour, waypoint))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to update Waypoint")
        |> add_breadcrumb(name: "Edit")
        |> render("edit.html", tour: tour, waypoint: waypoint, changeset: changeset)
    end
  end

  def delete(conn, _params, tour, waypoint) do
    Repo.delete!(waypoint)

    conn
    |> put_flash(:info, "Waypoint deleted")
    |> redirect(to: current_user_tour_path(conn, :show, tour))
  end
end
