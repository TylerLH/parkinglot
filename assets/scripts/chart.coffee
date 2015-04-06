window.$ = window.jQuery = require 'jquery'
require 'jquery-ui'
React = require 'react/addons'
d3 = require 'd3'
Rickshaw = require 'rickshaw'
moment = require 'moment'
_ = require 'underscore'

Chart = React.createClass
  displayName: 'Chart'

  renderGraph: ->
    graphEl = React.findDOMNode(@refs.chart)
    legendEl = React.findDOMNode(@refs.legend)
    sliderContainerEl = React.findDOMNode(@refs.sliderContainer)
    sliderEl = React.findDOMNode(@refs.slider)
    axis1El = React.findDOMNode(@refs.axis1)
    axis2El = React.findDOMNode(@refs.axis2)

    scales = []
    palette = new Rickshaw.Color.Palette

    # Determine the scales to use for each axis
    for series, i in @props.data
      min = _.min series, (point) -> point.y
      max = _.max series, (point) -> point.y
      if i is 0
        scale = d3.scale.linear()
      else
        scale = d3.scale.pow()
      scales.push scale.domain([min.y, max.y]).nice()

    graph = new Rickshaw.Graph
      element: graphEl
      renderer: 'line'
      stroke: true
      min: 'auto'
      height: graphEl.innerHeight
      width: graphEl.innerWidth
      series: [
        {
          name: 'Car Count'
          data: @props.data[0]
          color: palette.color()
          scale: scales[0]
        }
        {
          name: 'Weather'
          data: @props.data[1]
          color: palette.color()
          scale: scales[1]
        }
      ]

    graph.render()

    xAxis = new Rickshaw.Graph.Axis.X
      graph: graph
      tickFormat: (x) ->
        return moment(x).format('MM/DD/YYYY')
    xAxis.render()

    yAxisLeft = new Rickshaw.Graph.Axis.Y.Scaled
      graph: graph
      orientation: 'left'
      #tickFormat: Rickshaw.Fixtures.Number.formatKMBT
      element: axis1El
      scale: scales[0]
    yAxisLeft.render()

    yAxisRight = new Rickshaw.Graph.Axis.Y.Scaled
      graph: graph
      orientation: 'right'
      #tickFormat: Rickshaw.Fixtures.Number.formatKMBT
      element: axis2El
      scale: scales[1]
    yAxisRight.render()

    legend = new Rickshaw.Graph.Legend
      graph: graph
      element: legendEl

    hoverDetail = new Rickshaw.Graph.HoverDetail
      graph: graph
      xFormatter: (x) ->
        moment(x).format 'dddd, MMMM Do YYYY'

    toggle = new Rickshaw.Graph.Behavior.Series.Toggle
      graph: graph
      legend: legend

    highlighter = new Rickshaw.Graph.Behavior.Series.Highlight
      graph: graph
      legend: legend

    slider = new Rickshaw.Graph.RangeSlider.Preview
      graph: graph
      element: sliderEl
      height: sliderContainerEl.offsetHeight
      width: sliderContainerEl.offsetWidth
      minimumFrameWidth: 20

  componentDidMount: ->
    @renderGraph()

  render: ->
    <div className="chart-container">
      <div className="chart-top">
        <div className="y-axis first" ref="axis1"></div>
        <div className="chart" ref="chart"></div>
        <div className="y-axis" ref="axis2"></div>
      </div>
      <div className="chart-bottom">
        <div className="legend-container">
          <div className="legend" ref="legend"></div>
        </div>
        <div className="controls">
          <div className="slider-container" ref="sliderContainer">
            <div className="slider" ref="slider"></div>
          </div>
        </div>
      </div>
    </div>

module.exports = Chart
