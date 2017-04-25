defmodule LoadedBike.Lib.GPX2GeoJSONTest do
  use LoadedBike.ModelCase

  import LoadedBike.Web.Test.BuildUpload

  alias LoadedBike.Lib.GPX2GeoJSON

  test "convert" do
    map = %{
      type: "LineString",
      coordinates: [
        [8.89241667, 46.57608333, 2376],
        [8.89252778, 46.57619444, 2375],
        [8.89266667, 46.57641667, 2372]
      ]
    }
    assert {:ok, map} == GPX2GeoJSON.convert(build_upload(path: "test/files/test.gpx"))
  end

  test "convert with wrong extension" do
    assert {:error, "expected .gpx filename extension"} ==
      GPX2GeoJSON.convert(build_upload(path: "test/files/test.jpg"))
  end

  test "convert with malformed file" do
    assert {:error, "unable to parse .gpx file"} ==
      GPX2GeoJSON.convert(build_upload(path: "test/files/invalid.gpx"))
  end
end