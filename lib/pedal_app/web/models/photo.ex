defmodule PedalApp.Photo do
  use PedalApp.Web, :model
  use Arc.Ecto.Schema

  schema "photos" do
    field :file, PedalApp.Web.PhotoUploader.Type
    field :description, :string
    field :position, :integer

    belongs_to :waypoint, PedalApp.Waypoint, foreign_key: :waypoint_id

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :position])
    |> cast_attachments(params, [:file])
    |> validate_required([:file, :description])
  end
end
