import MainView             from "../../main"
import Map                  from "../../map"
import autoResizeTextArea   from "../../textarea"
import formattingHelpToggle from "../../formatting_help_toggle"

export default class UserWaypointEditView extends MainView {
  mount(){
    super.mount()

    var map = new Map()
    map.init()
    map.syncFormFields()
    map.addCrosshair()
    map.loadMarkers()

    autoResizeTextArea()
    formattingHelpToggle()
  }

  unmount(){
    super.unmount()
  }
}
