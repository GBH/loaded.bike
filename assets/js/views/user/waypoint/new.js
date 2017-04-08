import MainView           from "../../main"
import Map                from "../../map"
import autoResizeTextArea from "../../textarea"

export default class UserWaypointNewView extends MainView {
  mount(){
    super.mount()

    var map = new Map()
    map.init()

    // geolocate only if lat/long fields are blank
    const lat_field = document.getElementById("waypoint_lat")
    const lng_field = document.getElementById("waypoint_lng")
    if(lat_field.value == "" || lng_field.value == "") {
      map.geolocate()
    }

    map.syncFormFields()
    map.addCrosshair()
    map.loadMarkers()

    autoResizeTextArea()
  }

  unmount(){
    super.unmount()
  }
}
