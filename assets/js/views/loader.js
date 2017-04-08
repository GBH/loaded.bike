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


const views = {
  UserTourIndexView,
  UserTourNewView,
  UserTourShowView,
  UserTourEditView,
  UserWaypointShowView,
  UserWaypointEditView,
  UserWaypointNewView,
  UserPhotoNewView,
  UserPhotoEditView
}

export default function loadView(viewName){
  return views[viewName] || MainView
}
