import MainView         from "./main"
import WaypointShowView from "./waypoint/show"
import WaypointEditView from "./waypoint/edit"
import WaypointNewView  from "./waypoint/new"
import TourShowView     from "./tour/show"

const views = {
  WaypointShowView, WaypointEditView, WaypointNewView, TourShowView
}

export default function loadView(viewName){
  return views[viewName] || MainView
}
