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
      points = parse_xml_track(doc)
      points = if Enum.empty?(points) do
        parse_xml_route(doc)
      else
        points
      end
      {:ok, points}
    catch _, _ ->
      {:error, "unable to parse .gpx file"}
    end
  end

  defp parse_xml_track(doc) do
    xpath(doc, ~x"//trk/trkseg/trkpt"l, lat: ~x"./@lat"F, lng: ~x"./@lon"F, ele: ~x"./ele/text()"I)
  end

  defp parse_xml_route(doc) do
    xpath(doc, ~x"//rte/rtept"l, lat: ~x"./@lat"F, lng: ~x"./@lon"F)
  end

  defp build_map(points) do
    fun = fn
      (%{lng: lng, lat: lat, ele: ele}) -> [lng, lat, ele]
      (%{lng: lng, lat: lat})           -> [lng, lat]
    end
    coordinates = Enum.map(points, fun)
    %{type: "LineString", coordinates: coordinates}
  end
end
