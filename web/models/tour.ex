defmodule Pedal.Tour do
  use Pedal.Web, :model

  schema "tours" do
    field :title,       :string
    field :description, :string

    belongs_to :rider, Pedal.Rider

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description])
    |> validate_required([:title])
    |> assoc_constraint(:rider)
  end
end
