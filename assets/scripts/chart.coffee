window.$ = window.jQuery = require 'jquery'
require 'jquery-ui'
React = require 'react/addons'
d3 = require 'd3'
Rickshaw = require 'rickshaw'
require 'whatwg-fetch'
moment = require 'moment'

Chart = React.createClass
  displayName: 'Chart'

  renderGraph: ->
    graphEl = React.findDOMNode(@refs.chart)
    legendEl = React.findDOMNode(@refs.legend)
    sliderContainerEl = React.findDOMNode(@refs.sliderContainer)
    sliderEl = React.findDOMNode(@refs.slider)

    graph = new Rickshaw.Graph
      element: graphEl
      renderer: 'stack'
      stroke: true
      min: 'auto'
      height: graphEl.innerHeight
      width: graphEl.innerWidth
      series: @props.data

    graph.render()

    xAxis = new Rickshaw.Graph.Axis.X
      graph: graph
      tickFormat: (x) ->
        return moment(x).format('MM/DD/YYYY')
    xAxis.render()

    legend = new Rickshaw.Graph.Legend
      graph: graph
      element: legendEl

    hoverDetail = new Rickshaw.Graph.HoverDetail
      graph: graph

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
        <div className="chart" ref="chart"></div>
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
