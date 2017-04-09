defmodule LoadedBike.Web.HtmlHelpers do

  use Phoenix.HTML
  import LoadedBike.Web.Router.Helpers

  def published_badge(true) do
    content_tag(:span, "Published", class: "badge badge-pill badge-success")
  end

  def published_badge(false) do
    content_tag(:span, "Draft", class: "badge badge-pill badge-default")
  end

  def to_json(data) do
    Poison.encode!(data)
  end

  def markdown(nil), do: ""
  def markdown(body) do
    {_, html, _} = Earmark.as_html(body)
    HtmlSanitizeEx.markdown_html(html)
    |> raw
  end

  # Marking waypoint structs so we can properly render map
  def waypoints_to_json(conn, waypoints), do: waypoints_to_json(conn, waypoints, nil, nil)
  def waypoints_to_json(conn, waypoints, curr_waypoint, prev_waypoint) do
    is_marked = fn
      (_w, nil)   -> false
      (w, other)  -> w.id == other.id
    end

    waypoints
    |> Enum.map(fn(w) -> Map.put(w, :is_current, is_marked.(w, curr_waypoint)) end)
    |> Enum.map(fn(w) -> Map.put(w, :is_previous, is_marked.(w, prev_waypoint)) end)
    |> Enum.map(&Map.put(&1, :url, current_user_tour_waypoint_path(conn, :show, &1.tour_id, &1)))
    |> to_json
  end
end