import MainView         from "./main"
import TourIndexView    from "./tour/index"
import TourNewView      from "./tour/new"
import TourShowView     from "./tour/show"
import TourEditView     from "./tour/edit"
import WaypointShowView from "./waypoint/show"
import WaypointNewView  from "./waypoint/new"
import WaypointEditView from "./waypoint/edit"
import PhotoNewView     from "./photo/new"
import PhotoEditView    from "./photo/edit"


const views = {
  TourIndexView,
  TourNewView,
  TourShowView,
  TourEditView,
  WaypointShowView,
  WaypointEditView,
  WaypointNewView,
  PhotoNewView,
  PhotoEditView
}

export default function loadView(viewName){
  return views[viewName] || MainView
}
