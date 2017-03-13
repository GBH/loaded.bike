export default class Map {

  constructor(container_id) {
    const id = container_id || "map"
    const container = document.getElementById(id)

    this.map  = L.map(container)

    // defaulting location to Stanley Park if geolocation fails
    this.lat  = container.dataset.lat   || 49.3019608
    this.long = container.dataset.long  || -123.1507388
  }

  init() {
    const apiToken = "pk.eyJ1IjoiZ3JvY2VyeSIsImEiOiJjajA1cTZjdzQwNWR5Mndwa2dqM2l3ZnI4In0.MoTpE4qEHYKKYyOcfhd1Rg"

    const attribution = 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
      '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
      'Imagery © <a href="http://mapbox.com">Mapbox</a>'

    this.map.setView([this.lat, this.long], 13);

    L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=' + apiToken, {
      maxZoom:      18,
      minZoom:      8,
      attribution:  attribution,
      id:           'mapbox.streets'
    }).addTo(this.map)
  }

  geolocate() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition((pos) => {
        this.map.setView([pos.coords.latitude, pos.coords.longitude], 13)
      })
    }
  }

  sync_form_fields() {
    const lat_field   = document.getElementById("waypoint_lat")
    const long_field  = document.getElementById("waypoint_lng")

    this.map.on('moveend', (e) => {
      let center = this.map.getCenter()
      lat_field.value   = center.lat
      long_field.value  = center.lng
    })
  }
}
