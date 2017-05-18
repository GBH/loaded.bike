import MainView             from "./main"
import UserTourIndexView    from "./user/tour/index"
import UserTourNewView      from "./user/tour/new"
import UserTourShowView     from "./user/tour/show"
import UserTourEditView     from "./user/tour/edit"
import UserWaypointShowView from "./user/waypoint/show"
import UserWaypointNewView  from "./user/waypoint/new"
import UserWaypointEditView from "./user/waypoint/edit"
import UserPhotoNewView     from "./user/photo/new"
import UserPhotoEditView    from "./user/photo/edit"
import TourShowView         from "./tour/show"
import WaypointShowView     from "./waypoint/show"
import UserShowView         from "./user/show"
import UserEditView         from "./user/edit"

const views = {
  UserTourIndexView,
  UserTourNewView,
  UserTourShowView,
  UserTourEditView,
  UserWaypointShowView,
  UserWaypointEditView,
  UserWaypointNewView,
  UserPhotoNewView,
  UserPhotoEditView,
  TourShowView,
  WaypointShowView,
  UserShowView,
  UserEditView
}

export default function loadView(viewName){
  return views[viewName] || MainView
}
