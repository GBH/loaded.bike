defmodule PedalApp.Web.LayoutView do
  use PedalApp.Web, :view

  def page_identifier(conn) do
    view_name(conn) <> template_name(conn) <> "View"
  end

  defp view_name(conn) do
    conn
    |> view_module
    |> Phoenix.Naming.resource_name
    |> String.replace("_view", "")
    |> String.capitalize
  end

  defp template_name(conn) do
    conn.private.phoenix_template
    |> String.replace(".html", "")
    |> String.capitalize
  end
end
