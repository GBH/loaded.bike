defmodule PedalApp.Photo do
  use PedalApp.Web, :model
  use Arc.Ecto.Schema

  schema "photos" do
    field :file, PedalApp.Web.PhotoUploader.Type
    field :description, :string
    field :position, :integer
    field :uuid, :string

    belongs_to :waypoint, PedalApp.Waypoint, foreign_key: :waypoint_id

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :position])
    |> set_uuid
    |> cast_attachments(params, [:file])
    |> validate_required([:file, :uuid])
  end

  # deleting record and cleaning up attached files
  def delete!(photo) do
    PedalApp.Repo.delete!(photo)

    path =
      PedalApp.Web.PhotoUploader.url({photo.file, photo})
      |> String.split("?")
      |> List.first

    spawn fn ->
      PedalApp.Web.PhotoUploader.delete({path, photo})
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
