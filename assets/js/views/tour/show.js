import MainView from "../main"
import Map      from "../map"

export default class TourShowView extends MainView {
  mount(){
    super.mount()

    var map = new Map()
    if (map.container){
      map.init()
      map.loadMarkers()
      map.centerMarkers()
    }
  }

  unmount(){
    super.unmount()
  }
}
