export default class Map {

  constructor(container) {

    this.container = container || document.getElementById('map')
    this.map  = L.map(this.container, {attributionControl: false})

    // defaulting location to Stanley Park if geolocation fails
    this.lat = this.container.dataset.lat || 32.7507794
    this.lng = this.container.dataset.lng || -114.7650004

    // marker containers
    this.markers = []
    this.currentMarker = null
    this.previousMarker = null
  }

  init() {
    const apiToken = "pk.eyJ1IjoiZ3JvY2VyeSIsImEiOiJjajA1cTZjdzQwNWR5Mndwa2dqM2l3ZnI4In0.MoTpE4qEHYKKYyOcfhd1Rg"

    this.map.setView([this.lat, this.lng], 13);

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

    let iconDefault = this._getIcon()
    for (let [index, marker_json] of markers_json.entries()) {

      // selecting icon
      let icon = iconDefault
      if(marker_json.is_current){
        icon = this._getIcon('yellow')
      } else if (index == 0) {
        icon = this._getIcon('green')
      } else if (markers_json.length - 1 == index) {
        icon = this._getIcon('red')
      }

      // putting marker on map
      let marker = L.marker([marker_json.lat, marker_json.lng], {
        icon:   icon,
        title:  marker_json.title
      })
      marker.bindPopup("<a href='" + marker_json.url + "'>"+ marker_json.title +"</a>")
      marker.addTo(this.map)

      // registering markers for the map
      this.markers.push(marker)
      if(marker_json.is_current){
        this.currentMarker = marker
        marker.openPopup()
      }
      if(marker_json.is_previous){ this.previousMarker = marker }
    }
  }

  centerMarkers(){
    let markers = []
    if(this.currentMarker){markers.push(this.currentMarker)}
    if(this.previousMarker){markers.push(this.previousMarker)}
    if(markers.length == 0){markers = this.markers}

    if(markers.length == 0){return false}

    let group = new L.featureGroup(markers)
    this.map.fitBounds(group.getBounds(), {maxZoom: 13, padding: [30, 30]})
  }

  addCrosshair() {
    let marker = L.marker(this.map.getCenter(), {
      icon: this._getIcon('yellow'),
      clickable: false}
    )
    marker.addTo(this.map)

    this.map.on('move', (e) => {
      marker.setLatLng(this.map.getCenter())
    })
  }

  addPath() {
    if(!(this.currentMarker && this.previousMarker)){ return }

    let line = new L.polyline([this.previousMarker.getLatLng(), this.currentMarker.getLatLng()], {
      color:        '#4294cf',
      weight:       2,
      opacity:      0.5,
      dashArray:    '2, 5',
      smoothFactor: 1
    })
    line.addTo(this.map)
  }

  geolocate() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition((pos) => {
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

  _getIcon(color) {
    if (color === undefined) { return new L.Icon.Default() }
    return new CustomIcon({
      iconRetinaUrl:  "marker-icon-" + color + "-2x.png",
      iconUrl:        "marker-icon-" + color + ".png"
    })
  }
}

class CustomIcon extends L.Icon.Default {
  constructor(options) {
    options.imagePath = "/images/map/"
    super(options)
  }
}