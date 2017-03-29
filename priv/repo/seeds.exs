alias PedalApp.{Repo, User, Tour, Waypoint, Photo}

# create user
user = Repo.insert!(%User{
  email:        "test@test.test",
  name:         "Tester",
  password_hash: Comeonin.Bcrypt.hashpwsalt("password")
})

# create tour
tour = Repo.insert!(%Tour{
  user_id:      user.id,
  title:        "Can-Am Tour of 2016",
  description:  "",
  is_published: true
})

# create waypoints
json = File.read!("priv/repo/seed_data/waypoints.json")
data = Poison.Parser.parse!(json)

build_photo_upload = fn(index, filename) ->
  path = "/home/oleg/vm_share/Pictures/#{index}/#{filename}"
  %{__struct__: Plug.Upload, content_type: "image/jpg", path: path, filename: filename}
end

format_description = fn(string) ->
  case string do
    nil ->
      ""
    _ ->
      string
      |> String.split("\n")
      |> Enum.map(&String.trim_leading(&1))
      |> Enum.join("\n")
  end
end

data
|> Enum.with_index
|> Enum.each(fn({wp, index}) ->
  changeset = Waypoint.changeset(Ecto.build_assoc(tour, :waypoints), %{
    title:        wp["title"],
    lat:          wp["lat"],
    lng:          wp["lng"],
    position:     index,
    description:  format_description.(wp["description"]),
    is_published: true
  })
  waypoint = Repo.insert!(changeset)

  Enum.each(wp["photos"] || [], fn(photo) ->
    changeset = Photo.changeset(Ecto.build_assoc(waypoint, :photos), %{
      file:         build_photo_upload.(index, photo["file"]),
      description:  format_description.(photo["description"])
    })
    Repo.insert!(changeset)
  end)
end)
