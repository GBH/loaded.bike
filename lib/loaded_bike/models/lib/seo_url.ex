defimpl Phoenix.Param, for: LoadedBike.Tour do
  def to_param(%{id: id, title: title}) do
    "#{id}-#{Slugger.slugify_downcase(title)}"
  end
end

defimpl Phoenix.Param, for: LoadedBike.Waypoint do
  def to_param(%{id: id, title: title}) do
    "#{id}-#{Slugger.slugify_downcase(title)}"
  end
end
