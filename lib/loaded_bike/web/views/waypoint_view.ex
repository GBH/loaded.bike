defmodule LoadedBike.Web.WaypointView do
  use LoadedBike.Web, :view

  # Marking waypoint structs so we can properly render map
  def waypoints_to_json(conn, type, waypoints), do: waypoints_to_json(conn, type, waypoints, nil, nil)
  def waypoints_to_json(conn, type, waypoints, curr_waypoint, prev_waypoint) do
    is_marked = fn
      (_w, nil)   -> false
      (w, other)  -> w.id == other.id
    end

    link = fn
      (:public, waypoint) ->
        tour_waypoint_path(conn, :show, waypoint.tour_id, waypoint)
      (_, waypoint) ->
        current_user_tour_waypoint_path(conn, :show, waypoint.tour_id, waypoint)
    end

    waypoints
    |> Enum.map(fn(w) -> Map.put(w, :is_current, is_marked.(w, curr_waypoint)) end)
    |> Enum.map(fn(w) -> Map.put(w, :is_previous, is_marked.(w, prev_waypoint)) end)
    |> Enum.map(&Map.put(&1, :url, link.(type, &1)))
    |> Poison.encode!
  end
end