import MainView         from "./main"
import WaypointShowView from "./waypoint/show"

const views = {
  WaypointShowView
}

export default function loadView(viewName){
  return views[viewName] || MainView
}
