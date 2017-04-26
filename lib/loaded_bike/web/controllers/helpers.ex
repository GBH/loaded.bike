defmodule LoadedBike.Web.Controller.Helpers do

  defmacro __using__(_opts) do
    quote do
      def add_header_title(conn, title) do
        titles = Map.get(conn.assigns, :header_titles, [])
        titles = titles ++ [title]
        %{conn | assigns: Map.put(conn.assigns, :header_titles, titles)}
      end
    end
  end
end
