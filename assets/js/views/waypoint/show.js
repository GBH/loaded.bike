import MainView from "../main"

export default class WaypointShowView extends MainView {
  mount(){
    super.mount();

    var mapContainer = document.getElementById("map")
    var mymap = L.map('map').setView([mapContainer.dataset.lat, mapContainer.dataset.long], 13);

    L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZ3JvY2VyeSIsImEiOiJjajA1cTZjdzQwNWR5Mndwa2dqM2l3ZnI4In0.MoTpE4qEHYKKYyOcfhd1Rg', {
      maxZoom: 18,
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
        '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
        'Imagery © <a href="http://mapbox.com">Mapbox</a>',
      id: 'mapbox.streets'
    }).addTo(mymap);
  }

  unmount(){
    super.unmount();

    console.log("WPShowView unmounted")
  }
}