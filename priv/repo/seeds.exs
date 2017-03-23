alias PedalApp.{Repo, User, Tour, Waypoint}

lorem = ~s"""
# Repetit modo admovique pietas lateri stabat coniuge

Lorem markdownum gratus. *Vel deus motis* oculi errare sors ore [taedis
est](http://quodquedes.com/) malas est. *Pellem* geminae infringere venit licent
amantem adulterium perire Hector nec?

## Habebunt unum

*Ignes* est non; ademit Alpes fingetur audierit, se ille. Columbam terris centum
dentes laqueos pectore coniuge. Nostri urbes. Patriis sed quas. Certamen mediae.

1. Et vulnera et ipse
2. Imis erat Dixit caelum manus
3. Dum sonant nervos facibus et cingo non
4. Conlaudat virides

Aequales iam surgis **Phineus rapta**. Fatebitur annis. Humo huic **haut**
videntur buxum, est hac et miserum poterentur ipse erroribus [Veneris
Maeoniam](http://tesopor.com/pericula-casside). Perpetiar vipera tormentis eruit
concussaque agat hominum tantum atque daedalus mutare? Ille per mille et unde
**me sollicitis Aiaci** miserum visa sinus, nymphae Procrin mediis et aere
perlucida ignes.

**Vultus rege manus**, sua hinc tura aversa; est altoque dabat stamina via. Est
pro vitae mors, vix *hos Creten*, licet hauriret! Quaecumque rupem quoque silva
colle et istis in semina volentem ab meaque bibes.

Via visu secrevit, disparibus simul unius, Danais undas. Nostra saxum vidisti
veteres exclamo.

Illa illam deperit leve. Vitat ad esse creditus celeri de cumque! Sonabat
tamquam: nomen paries omnia, vulnera longum flebat donec pater confessis
**lassataque isset** utraque. In Parosque veteres vestigia creatis *moverat*;
vos ait qui, de oceano. Cycnus aeterna Hectoris lumina Pelethronium noverat ausa
ipse dissipat capillis functaque!

Arces queant vectabantur [cetera ferre](http://contagia.com/), verba agit
recepta abstulit. Exercita quoque amans ego formosissimus inpia ignes ne puro
aut nullos *hic* non clamor nactusque. Auro aeternus, Melantho parente.
"""

# create user
user = Repo.insert!(%User{
  email:        "test@test.test",
  name:         "Tester",
  password_hash: Comeonin.Bcrypt.hashpwsalt("password")
})

# create tour
tour = Repo.insert!(%Tour{
  user_id:      user.id,
  title:        "Test Tour of 2017",
  description:  lorem,
  is_published: true
})

# create waypoints
json = File.read!("priv/repo/seed_data/waypoints.json")
data = Poison.Parser.parse!(json)

data
|> Enum.with_index
|> Enum.each(fn({wp, index}) ->
  changeset = Waypoint.changeset(Ecto.build_assoc(tour, :waypoints), %{
    title:        wp["title"],
    lat:          wp["lat"],
    lng:          wp["lng"],
    position:     index,
    description:  lorem,
    is_published: true
  })
  Repo.insert!(changeset)
end)
