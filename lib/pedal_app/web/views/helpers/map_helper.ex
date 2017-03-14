defmodule PedalApp.Web.MapHelper do
  def waypoints_to_json(waypoints) do
    Poison.encode!(waypoints)
    |> String.replace("\"", "\\\"")
    |> Phoenix.HTML.raw
  end
end