defmodule PedalApp.Web.Controller.Helpers do

  defmacro __using__(_opts) do
    quote do

      # Loading tour into assigns based on param_key like "tour_id" or "id"
      defp load_tour(conn, param_key) do
        %{^param_key => tour_id} = conn.params
        tour =
          PedalApp.Repo.get!(assoc(conn.assigns.current_user, :tours), tour_id)
          |> PedalApp.Repo.preload(:waypoints)

        conn
        |> assign(:tour, tour)
        |> add_breadcrumb(name: "Tours", url: current_user_tour_path(conn, :index))
        |> add_breadcrumb(name: tour.title, url: current_user_tour_path(conn, :show, tour))
      end

      # Loading waypoint into assigns on param_key like "waypoint_id" or "id"
      defp load_waypoint(conn, param_key) do
        %{^param_key => id} = conn.params
        waypoint = PedalApp.Repo.get!(assoc(conn.assigns.tour, :waypoints), id)

        conn
        |> assign(:waypoint, waypoint)
        |> add_breadcrumb(
            name: waypoint.title,
            url: current_user_tour_waypoint_path(conn, :show, conn.assigns.tour, waypoint))
      end

      # Loading photo into assigns on param_key like "photo_id" or "id"
      defp load_photo(conn, param_key) do
        %{^param_key => id} = conn.params
        photo = PedalApp.Repo.get!(assoc(conn.assigns.waypoint, :photos), id)
        dom_id = PedalApp.Photo.dom_id(photo)
        url = current_user_tour_waypoint_path(conn, :show, conn.assigns.tour, conn.assigns.waypoint) <> "##{dom_id}"
        conn
        |> add_breadcrumb(name: "Photo", url: url)
        |> assign(:photo, photo)
      end

    end
  end
end