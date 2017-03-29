defmodule PedalApp.Web.PhotoUploader do
  use Arc.Definition
  use Arc.Ecto.Definition
  import Ecto.Query

  @versions [:large]

  # local storage
  def __storage, do: Arc.Storage.Local

  # Whitelist file extensions:
  def validate({file, _}) do
    ext = file.file_name
      |> Path.extname
      |> String.downcase
    Enum.member?(~w(.jpg .jpeg), ext)
  end

  # Define a thumbnail transformation:
  def transform(:large, _) do
    {:convert, "-strip -thumbnail 930x -gravity center -extent 930x -format jpg", :jpg}
  end

  # Override the persisted filenames:
  def filename(version, _) do
    version
  end

  # Override the storage directory:
  def storage_dir(version, {_file, photo}) do
    "uploads/waypoints/#{photo.waypoint_id}/photos/#{photo.uuid}/"
  end
end