import MainView from "../main"
import Map      from "../map"

export default class TourShowView extends MainView {
  mount(){
    super.mount()

    var map = new Map()
    map.init()
  }

  unmount(){
    super.unmount()
  }
}
