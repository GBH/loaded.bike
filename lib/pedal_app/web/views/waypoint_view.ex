defmodule PedalApp.Web.WaypointView do
  use PedalApp.Web, :view

  def markdown(body) do
    {_, html, _} = Earmark.as_html(body)
    HtmlSanitizeEx.markdown_html(html) |> raw
  end
end