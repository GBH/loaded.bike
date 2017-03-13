export default class Map {

  constructor(container_id) {
    const id = container_id || "map"
    const container = document.getElementById(id)

    this.map  = L.map(container, {attributionControl: false})

    // defaulting location to Stanley Park if geolocation fails
    this.lat  = container.dataset.lat   || 49.3019608
    this.long = container.dataset.long  || -123.1507388
  }

  init() {
    const apiToken = "pk.eyJ1IjoiZ3JvY2VyeSIsImEiOiJjajA1cTZjdzQwNWR5Mndwa2dqM2l3ZnI4In0.MoTpE4qEHYKKYyOcfhd1Rg"

    this.map.setView([this.lat, this.long], 13);

    const layer = L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=' + apiToken, {
      maxZoom:      18,
      minZoom:      8,
      id:           'mapbox.streets'
    })
    this.map.addControl(layer)
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
