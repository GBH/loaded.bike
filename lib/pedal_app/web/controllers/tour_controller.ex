defmodule PedalApp.Web.TourController do
  use PedalApp.Web, :controller

  alias PedalApp.Tour

  plug :load_tour, "id"       when action in [:show, :edit, :update, :delete]
  plug :scrub_params, "tour"  when action in [:create, :update]

  defp action(conn, _) do
    attrs = if conn.assigns[:tour] do
      [conn, conn.params, conn.assigns.current_user, conn.assigns.tour]
    else
      [conn, conn.params, conn.assigns.current_user]
    end
    apply(__MODULE__, action_name(conn), attrs)
  end

  # -- Actions -----------------------------------------------------------------
  def index(conn, _, current_user) do
    tours = Repo.all(
      from t in assoc(current_user, :tours),
      order_by: [desc: t.inserted_at],
      preload:  [:waypoints]
    )

    conn
    |> add_breadcrumb(name: "Tours")
    |> render("index.html", tours: tours)
  end

  def show(conn, _params, current_user, tour) do
    waypoints = Repo.all(from w in assoc(tour, :waypoints), order_by: w.inserted_at)
    render(conn, "show.html", tour: tour, waypoints: waypoints)
  end

  def new(conn, _, current_user) do
    changeset = current_user
    |> build_assoc(:tours)
    |> Tour.changeset

    conn
    |> add_breadcrumb(name: "New Tour")
    |> render("new.html", changeset: changeset)
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
        |> put_flash(:error, "Failed to create Tour")
        |> add_breadcrumb(name: "New Tour")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, _params, current_user, tour) do
    changeset = Tour.changeset(tour)
    conn
    |> add_breadcrumb(name: "Edit")
    |> render("edit.html", tour: tour, changeset: changeset)
  end

  def update(conn, %{"tour" => tour_params}, current_user, tour) do
    changeset = Tour.changeset(tour, tour_params)

    case Repo.update(changeset) do
      {:ok, tour} ->
        conn
        |> put_flash(:info, "Tour updated")
        |> redirect(to: current_user_tour_path(conn, :show, tour))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to update Tour")
        |> add_breadcrumb(name: "Edit")
        |> render("edit.html", tour: tour, changeset: changeset)
    end
  end

  def delete(conn, _params, current_user, tour) do
    Repo.delete!(tour)

    conn
    |> put_flash(:info, "Tour deleted")
    |> redirect(to: current_user_tour_path(conn, :index))
  end
end
