defmodule LoadedBike.Web.TourView do
  use LoadedBike.Web, :view
  import Kerosene.HTML

  def waypoint_css_class(total, index) do
    cond do
      index == 0 ->
        "start"
      index == total - 1 ->
        "finish"
      rem(index + 1, 7) == 0 ->
        "week"
      true ->
        ""
    end
  end
end