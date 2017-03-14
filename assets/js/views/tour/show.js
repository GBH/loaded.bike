import MainView from "../main"
import Map      from "../map"

export default class TourShowView extends MainView {
  mount(){
    super.mount()

    var map = new Map()
    map.init()
    map.load_markers()
  }

  unmount(){
    super.unmount()
  }
}
