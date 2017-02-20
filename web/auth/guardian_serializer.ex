defmodule Pedal.GuardianSerializer do
  @behavior Guardian.Serializer

  alias Pedal.Repo
  alias Pedal.Rider

  def for_token(rider = %Rider{}), do: {:ok, "Rider:#{rider.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("Rider:" <> id), do: {:ok, Repo.get(Rider, id)}
  def from_token(_), do: {:error, "Unknown resource type"}
end