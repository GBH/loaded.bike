defmodule LoadedBike.Web.AvatarUploader do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:large, :small]

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
    {:convert, "-strip -thumbnail 200x200^ -gravity center -crop 200x200+0+0 -format jpg", :jpg}
  end

  def transform(:small, _) do
    {:convert, "-strip -thumbnail 32x32^ -gravity center -crop 32x32+0+0 -format jpg", :jpg}
  end

  # Override the persisted filenames:
  def filename(version, _) do
    version
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, user}) do
    "uploads/users/#{user.id}/"
  end
end
