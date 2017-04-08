import MainView           from "../../main"
import autoResizeTextArea from "../../textarea"

export default class UserPhotoEditView extends MainView {
  mount(){
    super.mount()
    autoResizeTextArea()
  }

  unmount(){
    super.unmount()
  }
}