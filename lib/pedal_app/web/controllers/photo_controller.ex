defmodule PedalApp.Web.PhotoController do
  use PedalApp.Web, :controller

  alias PedalApp.Photo

  plug :scrub_params, "photo" when action in [:create, :update]
  plug :load_tour
  plug :load_waypoint

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
      {:ok, photo} ->
        conn
        |> put_flash(:info, "Photo created")
        |> redirect(to: current_user_tour_waypoint_path(conn, :show, tour, waypoint))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => id}, tour, waypoint) do

  end

  def update(conn, %{"id" => id, "photo" => photo_params}, tour, waypoint) do

  end

  def delete(conn, %{"id" => id}, tour, waypoint) do

  end
end