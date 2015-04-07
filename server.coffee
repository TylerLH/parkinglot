express   = require 'express'
app       = express()
fs        = require 'fs'
parseCSV  = require 'csv-parse'
_         = require 'underscore'
d3        = require 'd3'

app.use express.static __dirname + "/public"

# Date formatter for timestamps in CSV
formatDate = d3.time.format("%Y-%m-%d")

# Parse the sample data file & send formatted JSON for graph
app.get '/data', (req, res, next) ->
  data = [ [], [] ]
  fs.readFile __dirname + "/data/data.csv", (err, result) ->
    return next(err) if err?
    parseOpts =
      columns: true
      auto_parse: true
      skip_empty_lines: true
    parseCSV result, parseOpts, (err, output) ->
      return next(err) if err?

      # Remove rows with missing data or useless values
      output = _.reject output, (row) ->
        !_.isFinite row['car.count'] || !_.isFinite row['weather']

      # Format JSON to include relevant fields
      output = _.sample output, 200
      _.each output, (row) ->
        date = formatDate.parse(row.date).getTime()
        data[0].push {x: date, y: row['car.count']}
        data[1].push {x: date, y: row['weather']}

      # Send formatted data
      res.json data

# Error handling middleware
app.use (err, req, res, next) ->
  console.log err.stack
  res.status(500).send "Server Error!"

app.listen process.env.PORT || 3000, ->
  console.log "Server started and is listening for requests."
