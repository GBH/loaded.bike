defmodule LoadedBike.Web.TourCommander do
  use Drab.Commander

  import Ecto
  import Ecto.Query

  alias LoadedBike.{Repo, Waypoint, Photo}

  def load_more(socket, _sender) do

    tour          = Drab.Live.peek(socket, :tour)
    last_waypoint = Drab.Live.peek(socket, :last_waypoint)
    waypoints     = Drab.Live.peek(socket, :waypoints)

    photos_query = Photo
      |> order_by(asc: :inserted_at)

    new_waypoints = assoc(tour, :waypoints)
      |> Waypoint.published
      |> select([:id, :tour_id, :title, :description, :position])
      |> preload(photos: ^photos_query)
      |> order_by(asc: :position)
      |> where([w], w.id > ^last_waypoint.id)
      |> limit(3)
      |> Repo.all

    Drab.Live.poke(socket,
      waypoints:      waypoints ++ new_waypoints,
      last_waypoint:  List.last(new_waypoints)
    )
  end
end
