import MainView from "../main"
import Map      from "../map"

export default class WaypointEditView extends MainView {
  mount(){
    super.mount()

    var map = new Map()
    map.init()
    map.syncFormFields()
    map.addCrosshair()
    map.loadMarkers()
  }

  unmount(){
    super.unmount()
  }
}
