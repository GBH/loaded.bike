defmodule PedalApp.Web.TourController do
  use PedalApp.Web, :controller

  alias PedalApp.Tour

  plug :scrub_params, "tour" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  # -- Actions -----------------------------------------------------------------
  def index(conn, _, current_user) do
    tours = Repo.all(assoc(current_user, :tours))
    render(conn, "index.html", tours: tours)
  end

  def show(conn, %{"id" => id}, current_user) do
    tour = Repo.get!(assoc(current_user, :tours), id)
    waypoints = Repo.all(from w in assoc(tour, :waypoints), order_by: w.inserted_at)

    render(conn, "show.html", tour: tour, waypoints: waypoints)
  end

  def new(conn, _, current_user) do
    changeset = current_user
    |> build_assoc(:tours)
    |> Tour.changeset

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tour" => tour_params}, current_user) do
    changeset = current_user
    |> build_assoc(:tours)
    |> Tour.changeset(tour_params)

    case Repo.insert(changeset) do
      {:ok, tour} ->
        conn
        |> put_flash(:info, "Tour created")
        |> redirect(to: current_user_tour_path(conn, :show, tour))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    tour = Repo.get!(assoc(current_user, :tours), id)
    changeset = Tour.changeset(tour)
    render(conn, "edit.html", tour: tour, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tour" => tour_params}, current_user) do
    tour = Repo.get!(assoc(current_user, :tours), id)
    changeset = Tour.changeset(tour, tour_params)

    case Repo.update(changeset) do
      {:ok, tour} ->
        conn
        |> put_flash(:info, "Tour updated")
        |> redirect(to: current_user_tour_path(conn, :show, tour))
      {:error, changeset} ->
        render(conn, "edit.html", tour: tour, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    tour = Repo.get!(assoc(current_user, :tours), id)
    Repo.delete!(tour)

    conn
    |> put_flash(:info, "Tour deleted")
    |> redirect(to: current_user_tour_path(conn, :index))
  end
end
