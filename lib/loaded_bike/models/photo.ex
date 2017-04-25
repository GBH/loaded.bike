defmodule LoadedBike.Photo do
  use LoadedBike.Web, :model
  use Arc.Ecto.Schema

  schema "photos" do
    field :file,        LoadedBike.Web.PhotoUploader.Type
    field :description, :string
    field :position,    :integer
    field :uuid,        :string

    belongs_to :waypoint, LoadedBike.Waypoint, foreign_key: :waypoint_id

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :position])
    |> set_uuid
    |> cast_attachments(params, [:file])
    |> assoc_constraint(:waypoint)
    |> validate_required([:waypoint_id, :file, :uuid])
  end

  # deleting record and cleaning up attached files
  def delete!(photo) do
    LoadedBike.Repo.delete!(photo)

    path =
      LoadedBike.Web.PhotoUploader.url({photo.file, photo})
      |> String.split("?")
      |> List.first

    spawn fn ->
      LoadedBike.Web.PhotoUploader.delete({path, photo})
    end
  end

  # because of reasons, we need uuid to link uploaded files properly
  defp set_uuid(changeset) do
    case Ecto.get_meta(changeset.data, :state) do
      :built ->
        put_change(changeset, :uuid, Ecto.UUID.generate)
      :loaded ->
        changeset
    end
  end
end
