defmodule PedalApp.Web.PhotoUploader do
  use Arc.Definition
  use Arc.Ecto.Definition
  import Ecto
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
  def storage_dir(version, {file, photo}) do
    waypoint_id = photo.waypoint_id
    tour_id = PedalApp.Repo.one!(from w in PedalApp.Waypoint, select: w.tour_id, where: w.id == ^waypoint_id)
    "uploads/tours/#{tour_id}/waypoints/#{waypoint_id}/photos/#{photo.uuid}/"
  end
end