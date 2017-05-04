export default class ElevationGraph {

  constructor(container) {
    this.mapContainer = container || document.getElementById('map')
    this.x      = null
    this.y      = null
    this.xAxis  = null
    this.yAxis  = null
    this.area   = null
    this.data   = null
  }

  init() {
    let track = JSON.parse(this.mapContainer.dataset.track)

    // no track, no data, we bail
    if(!track){ return }

    this.data  = this._transformTrackData(track)

    // if we got no elevation data
    if (this.data[0].y == undefined){ return }

    window.addEventListener('resize', this.render.bind(this))

    let minDistance = 0
    let maxDistance = d3.max(this.data, function(d) { return d.x })
    this.x = d3.scaleLinear().domain([minDistance, maxDistance])

    let minElevation = d3.min(this.data, function(d) { return d.y }) - 50
    let maxElevation = d3.max(this.data, function(d) { return d.y }) + 50
    this.y = d3.scaleLinear().domain([minElevation, maxElevation])

    this.xAxis = d3.axisBottom()
      .scale(this.x)
      .tickSizeOuter(0)
      .tickPadding(10)
      .tickFormat(function(d){ return d + " km"})

    this.yAxis = d3.axisLeft()
      .scale(this.y)
      .tickSizeOuter(0)
      .tickPadding(5)
      .tickFormat(function(d){ return d + " m"})

    this.area = d3.area()
      .x(function(d){ return this.x(d.x) }.bind(this))
      .y1(function(d){ return this.y(d.y) }.bind(this))

    this.render()
  }

  render(){
    // blow away entire container if we need to re-render this
    let container = document.getElementById("elevation-graph")
    if (container) {
      container.remove()
    }

    let svgContainer = document.createElement("div")
    svgContainer.setAttribute("id", "elevation-graph")
    this.mapContainer.parentNode.insertBefore(svgContainer, this.mapContainer.nextSibling)

    let containerWidth = this.mapContainer.offsetWidth
    let margin  = {top: 5, right: 0, bottom: 30, left: 40}
    let width   = containerWidth - margin.left - margin.right
    let height  = 150 - margin.top - margin.bottom

    this.x.range([0, width])
    this.y.range([height, 0])

    let xAxisTicksFreq = 10
    if(width < 768){ xAxisTicksFreq = 5 }

    this.xAxis
      .ticks(xAxisTicksFreq, "r")
      .tickSizeInner(-height)

    this.yAxis
      .ticks(5, "r")
      .tickSizeInner(-width)

    this.area.y0(height)

    let svg = d3.select(svgContainer)
      .append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

    svg.append("path")
      .datum(this.data)
      .attr("class", "area")
      .attr("d", this.area)

    svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(this.xAxis)

    svg.append("g")
      .attr("class", "y axis")
      .call(this.yAxis)
  }

  // transforming GeoJSON into array with current distance and elevation
  _transformTrackData(data){
    if(!data){ return }

    let coordinates = data.coordinates
    let distance  = 0
    let prevPoint = null

    return coordinates.map(function(coord){
      let thisPoint = L.latLng(coord[1], coord[0])

      if(prevPoint){
        distance = distance + (prevPoint.distanceTo(thisPoint) / 1000)
      }
      prevPoint = thisPoint

      return {x: distance, y: coord[2]}
    })
  }
}
