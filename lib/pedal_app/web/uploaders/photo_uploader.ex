defmodule PedalApp.Web.PhotoUploader do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original, :thumb]

  # local storage
  def __storage, do: Arc.Storage.Local

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 100x100^ -gravity center -extent 100x100 -format jpg", :jpg}
  end

  # Override the persisted filenames:
  def filename(version, _) do
    version
  end

  # Override the storage directory:
  def storage_dir(version, {file, photo}) do
    "uploads/photos/#{photo.uuid}/"
  end
end