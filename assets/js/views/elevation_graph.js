export default class ElevationGraph {

  constructor(container) {
    this.container = container || document.getElementById('map')

    let track = JSON.parse(this.container.dataset.track)
    this.dataPoints = this._transformTrackData(track)
  }

  render() {
    let data = this.dataPoints;

    if(!data){ return }

    let containerWidth = this.container.offsetWidth

    let margin  = {top: 0, right: 0, bottom: 30, left: 50}
    let width   = containerWidth - margin.left - margin.right
    let height  = 150 - margin.top - margin.bottom

    let x = d3.scaleLinear()
        .domain([0, d3.max(data, function(d) { return d.x })])
        .range([0, width]);

    let minElevation = d3.min(data, function(d) { return d.y }) - 50
    let maxElevation = d3.max(data, function(d) { return d.y }) + 50
    let y = d3.scaleLinear()
        .domain([minElevation, maxElevation])
        .range([height, 0])

    let xAxisTicksFreq = 10
    if(width < 768){
      xAxisTicksFreq = 5
    }

    let xAxis = d3.axisBottom()
      .scale(x)
      .tickSizeInner(-height)
      .tickSizeOuter(0)
      .tickPadding(10)
      .ticks(xAxisTicksFreq, "r")
      .tickFormat(function(d){ return d + " km"})

    let yAxis = d3.axisLeft()
      .scale(y)
      .tickSizeInner(-width)
      .tickSizeOuter(0)
      .tickPadding(5)
      .ticks(5, "r")
      .tickFormat(function(d){ return d + " m"})

    let area = d3.area()
      .x(function(d) { return x(d.x) })
      .y0(height)
      .y1(function(d) { return y(d.y) })

    let svgContainer = document.createElement("div")
    svgContainer.setAttribute("id", "elevation-graph")

    this.container.parentNode.insertBefore(svgContainer, this.container.nextSibling)

    let svg = d3.select(svgContainer)
      .append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

    svg.append("path")
      .datum(data)
      .attr("class", "area")
      .attr("d", area)

    svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis)

    svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
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
