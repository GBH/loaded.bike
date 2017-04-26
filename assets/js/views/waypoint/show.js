import MainView       from "../main"
import Map            from "../map"
import ElevationGraph from "../elevation_graph"

export default class WaypointShowView extends MainView {
  mount(){
    super.mount()

    let map = new Map()
    map.init()
    map.loadMarkers()
    map.centerMarkers()
    map.addPath()

    let graph = new ElevationGraph()
    graph.render()
  }

  unmount(){
    super.unmount()
  }
}