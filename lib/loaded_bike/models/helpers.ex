defmodule LoadedBike.Model.Helpers do

  defmacro __using__(_args) do
    quote do

      def dom_id(struct) do
        name = struct.__struct__
        |> Atom.to_string
        |> String.split(".")
        |> List.last
        |> String.downcase

        "#{name}-#{struct.id}"
      end

    end
  end
end