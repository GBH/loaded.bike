require IEx

defmodule PedalApp.Web.WaypointController do
  use PedalApp.Web, :controller

  alias PedalApp.Waypoint

  plug :scrub_params, "waypoint" when action in [:create, :update]
  plug :load_tour

  defp load_tour(conn, _) do
    %{"tour_id" => tour_id} = conn.params
    tour = Repo.get!(assoc(conn.assigns.current_user, :tours), tour_id)
    tour = Repo.preload(tour, :waypoints)
    assign(conn, :tour, tour)
  end

  defp action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.tour]
    )
  end

  # -- Actions -----------------------------------------------------------------
  def index(conn, _, tour) do
    waypoints = Repo.all(from w in assoc(tour, :waypoints), order_by: w.inserted_at)
    render(conn, "index.html", tour: tour, waypoints: waypoints)
  end

  def show(conn, %{"id" => id}, tour) do
    waypoint = Repo.get!(assoc(tour, :waypoints), id)
    waypoint = Repo.preload(waypoint, :photos)
    render conn, "show.html", tour: tour, waypoint: waypoint
  end

  def new(conn, _, tour) do
    changeset = tour
    |> build_assoc(:waypoints)
    |> Waypoint.changeset

    render(conn, "new.html", tour: tour, changeset: changeset)
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
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}, tour) do
    waypoint = Repo.get!(assoc(tour, :waypoints), id)
    tour = %{tour | waypoints: Enum.reject(tour.waypoints, fn(w) -> w.id == waypoint.id end)}
    changeset = Waypoint.changeset(waypoint)
    render conn, "edit.html", tour: tour, waypoint: waypoint, changeset: changeset
  end

  def update(conn, %{"id" => id, "waypoint" => waypoint_params}, tour) do
    waypoint = Repo.get!(assoc(tour, :waypoints), id)
    changeset = Waypoint.changeset(waypoint, waypoint_params)

    case Repo.update(changeset) do
      {:ok, waypoint} ->
        conn
        |> put_flash(:info, "Waypoint updated")
        |> redirect(to: current_user_tour_waypoint_path(conn, :show, tour, waypoint))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to update Waypoint")
        |> render("edit.html", tour: tour, waypoint: waypoint, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, tour) do
    waypoint = Repo.get!(assoc(tour, :waypoints), id)
    Repo.delete!(waypoint)

    conn
    |> put_flash(:info, "Waypoint deleted")
    |> redirect(to: current_user_tour_waypoint_path(conn, :index, tour))
  end
end