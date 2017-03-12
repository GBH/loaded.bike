import MainView from "../main"
import Map from "../map"

export default class WaypointEditView extends MainView {
  mount(){
    super.mount()

    var map = new Map()
    map.init()
    map.update_form_fields()
  }

  unmount(){
    super.unmount()
  }
}