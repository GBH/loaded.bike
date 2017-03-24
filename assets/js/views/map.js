export default class Map {

  constructor(container) {

    this.container = container || document.getElementById('map')
    this.map  = L.map(this.container, {attributionControl: false})

    // defaulting location to Stanley Park if geolocation fails
    this.lat  = this.container.dataset.lat   || 49.3019608
    this.long = this.container.dataset.long  || -123.1507388

    // markers container
    this.markers = []
  }

  init() {
    const apiToken = "pk.eyJ1IjoiZ3JvY2VyeSIsImEiOiJjajA1cTZjdzQwNWR5Mndwa2dqM2l3ZnI4In0.MoTpE4qEHYKKYyOcfhd1Rg"

    this.map.setView([this.lat, this.long], 13);

    const layer = L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=' + apiToken, {
      maxZoom: 18,
      minZoom: 3,
      id:      'mapbox.streets'
    })
    this.map.addControl(layer)
  }

  loadMarkers() {
    const markers_json = JSON.parse(this.container.dataset.markers)

    // no markers to show, centering map on current location
    if (markers_json.length == 0) {
      this.geolocate()
      return false
    }

    // adding markers to the map
    let markers = []
    for (let marker_json of markers_json) {
      let marker = L.marker([marker_json.lat, marker_json.lng], {title: marker_json.title})
      marker.addTo(this.map)
      this.markers.push(marker)
    }
  }

  centerMarkers(){
    let group = new L.featureGroup(this.markers)
    this.map.fitBounds(group.getBounds())
  }

  addCrosshair() {
    let marker = L.marker(this.map.getCenter(), {clickable: false})
    marker.addTo(this.map)

    this.map.on('move', (e) => {
      marker.setLatLng(this.map.getCenter())
    })
  }

  geolocate() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition((pos) => {
        console.log([pos.coords.latitude, pos.coords.longitude])
        this.map.setView([pos.coords.latitude, pos.coords.longitude], 13)
      })
    }
  }

  syncFormFields() {
    const lat_field   = document.getElementById("waypoint_lat")
    const long_field  = document.getElementById("waypoint_lng")

    this.map.on('moveend', (e) => {
      let center = this.map.getCenter()
      lat_field.value   = center.lat
      long_field.value  = center.lng
    })
  }
}
