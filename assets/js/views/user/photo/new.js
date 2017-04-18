import MainView             from "../../main"
import autoResizeTextArea   from "../../textarea"
import formattingHelpToggle from "../../formatting_help_toggle"

export default class UserPhotoNewView extends MainView {
  mount(){
    super.mount()
    autoResizeTextArea()
    formattingHelpToggle()
  }

  unmount(){
    super.unmount()
  }
}
