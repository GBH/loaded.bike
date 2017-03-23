import MainView from "../main"
import Map      from "../map"

export default class TourIndexView extends MainView {
  mount(){
    super.mount()

    const maps = document.querySelectorAll('.map[data-map]')
    for (let map of maps) {
      var map = new Map(map)
      map.init()
      map.load_markers()
    }
  }

  unmount(){
    super.unmount()
  }
}
