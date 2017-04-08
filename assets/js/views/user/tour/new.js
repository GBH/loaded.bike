import MainView           from "../../main"
import autoResizeTextArea from "../../textarea"

export default class UserTourNewView extends MainView {
  mount(){
    super.mount()
    autoResizeTextArea()
  }

  unmount(){
    super.unmount()
  }
}
