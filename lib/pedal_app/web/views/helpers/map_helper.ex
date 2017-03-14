defmodule PedalApp.Web.MapHelper do
  def waypoints_to_json(waypoints) do
    Poison.encode!(waypoints)
  end
end