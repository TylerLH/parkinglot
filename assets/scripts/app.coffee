Chart = require './chart'
React = require 'react'
require 'whatwg-fetch'

App = React.createClass
  displayName: 'App'

  getInitialState: ->
    {loading: true}

  componentDidMount: ->
    @loadGraphData()

  loadGraphData: ->
    fetch('/data').then (response) =>
      response.json().then (json) =>
        @setState
          graph_data: json
          loading: false

  render: ->
    if @state.loading
      <div className="loading-message">
         <h1><i className="fa fa-circle-o-notch fa-spin"></i> Loading graph, please wait.</h1>
      </div>
    else
      <Chart data={@state.graph_data}/>


React.render <App/>, document.getElementById "app"
