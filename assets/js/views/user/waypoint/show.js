import MainView from "../../main"
import Map      from "../../map"

export default class UserWaypointShowView extends MainView {
  mount(){
    super.mount()

    var map = new Map()
    map.init()
    map.loadMarkers()
    map.centerMarkers()
    map.addPath()
  }

  unmount(){
    super.unmount()
  }
}
