# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PedalApp.Repo.insert!(%PedalApp.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PedalApp.{Repo, Tour, Waypoint}

json = File.read!("priv/repo/seed_data/waypoints.json")

data = Poison.Parser.parse!(json)

tour = Repo.get!(Tour, 1)

data
|> Enum.with_index
|> Enum.each(fn({wp, index}) ->
  changeset = Waypoint.changeset(Ecto.build_assoc(tour, :waypoints), %{
    title:    wp["title"],
    lat:      wp["lat"],
    lng:      wp["lng"],
    position: index
  })
  Repo.insert!(changeset)
end)
