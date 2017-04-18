defmodule LoadedBike.Web.TourView do
  use LoadedBike.Web, :view
  import Kerosene.HTML

  def waypoint_css_class(tour, index) do
    total = length(tour.waypoints)
    cond do
      index == 0 ->
        "start"
      index == total - 1 && tour.is_completed ->
        "finish"
      rem(index + 1, 7) == 0 ->
        "week"
      true ->
        ""
    end
  end

  def completed_badge(true) do
    content_tag(:span, "Completed", class: "badge badge-pill badge-success")
  end

  def completed_badge(false) do
    content_tag(:span, "On the road", class: "badge badge-pill badge-warning")
  end
end