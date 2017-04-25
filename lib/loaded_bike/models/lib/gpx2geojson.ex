defmodule LoadedBike.Lib.GPX2GeoJSON do

  import SweetXml

  def convert(%Plug.Upload{filename: filename, path: path}) do
    with  {:ok}         <- validate_extension(filename),
          {:ok, doc}    <- File.read(path),
          {:ok, points} <- parse_xml(doc)
    do
      {:ok, build_map(points)}
    else
      error -> error
    end
  end

  defp validate_extension(filename) do
    ext = filename
      |> Path.extname
      |> String.downcase
    case ext do
      ".gpx"  -> {:ok}
      _       -> {:error, "expected .gpx filename extension"}
    end
  end

defp parse_xml(doc) do
  try do
    points = xpath(doc, ~x"//trk/trkseg/trkpt"l, lat: ~x"./@lat"F, lng: ~x"./@lon"F, ele: ~x"./ele/text()"I)
    {:ok, points}
  catch _, _ ->
    {:error, "unable to parse .gpx file"}
  end
end

  defp build_map(points) do
    coordinates = Enum.map(points, &([&1[:lat], &1[:lng], &1[:ele]]))
    %{
      type:     "LineString",
      geometry: %{ coordinates: coordinates }
    }
  end
end
