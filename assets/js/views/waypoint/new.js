import MainView from "../main"
import Map      from "../map"

export default class WaypointNewView extends MainView {
  mount(){
    super.mount()

    var map = new Map()
    map.init()

    // geolocate only if lat/long fields are blank
    const lat_field   = document.getElementById("waypoint_lat")
    const long_field  = document.getElementById("waypoint_lng")
    if(lat_field.value == "" || long_field.value == "") {
      map.geolocate()
    }

    map.syncFormFields()
    map.addCrosshair()
    map.loadMarkers()
  }

  unmount(){
    super.unmount()
  }
}
