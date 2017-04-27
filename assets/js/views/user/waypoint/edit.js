import MainView             from "../../main"
import Map                  from "../../map"
import autoResizeTextArea   from "../../textarea"
import formattingHelpToggle from "../../formatting_help_toggle"
import ElevationGraph       from "../../elevation_graph"

export default class UserWaypointEditView extends MainView {
  mount(){
    super.mount()

    var map = new Map()
    map.init()
    map.syncFormFields()
    map.addCrosshair()
    map.loadMarkers()
    map.addPath()

    let graph = new ElevationGraph()
    graph.init()

    autoResizeTextArea()
    formattingHelpToggle()
  }

  unmount(){
    super.unmount()
  }
}
