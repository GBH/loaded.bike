defmodule LoadedBike.Web.WaypointView do
  use LoadedBike.Web, :view

  def to_json(data) do
    Poison.encode!(data)
  end

  # Marking waypoint structs so we can properly render map
  def waypoints_to_json(conn, tour, type), do: waypoints_to_json(conn, tour, type, nil, nil)
  def waypoints_to_json(conn, tour, type, curr_waypoint, prev_waypoint) do
    tour.waypoints
    |> Enum.map(&set_is_marked(&1, :is_current, curr_waypoint))
    |> Enum.map(&set_is_marked(&1, :is_previous, prev_waypoint))
    |> Enum.map(&Map.put(&1, :url, set_link(conn, &1, type)))
    |> set_is_finish(tour.status == :completed)
    |> to_json
  end

  defp set_is_marked(waypoint, _attr, nil),           do: waypoint
  defp set_is_marked(waypoint, attr, other_waypoint)  do
    if waypoint.id == other_waypoint.id do
      Map.put(waypoint, attr, true)
    else
      waypoint
    end
  end

  defp set_link(conn, waypoint, :public) do
    tour_waypoint_path(conn, :show, waypoint.tour_id, waypoint)
  end
  defp set_link(conn, waypoint, :private) do
    current_user_tour_waypoint_path(conn, :show, waypoint.tour_id, waypoint)
  end

  defp set_is_finish([], _),             do: []
  defp set_is_finish(waypoints, false),  do: waypoints
  defp set_is_finish(waypoints, true)    do
    wp = waypoints
      |> List.last
      |> Map.put(:is_finish, true)
    List.replace_at(waypoints, -1, wp)
  end
end
