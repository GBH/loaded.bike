import MainView         from "./main"
import WaypointShowView from "./waypoint/show"
import WaypointEditView from "./waypoint/edit"
import WaypointNewView  from "./waypoint/new"

const views = {
  WaypointShowView, WaypointEditView, WaypointNewView
}

export default function loadView(viewName){
  return views[viewName] || MainView
}
