gulp        = require 'gulp'
$           = do require 'gulp-load-plugins'
browserify  = require 'browserify'
watchify    = require 'watchify'
source      = require 'vinyl-source-stream'
fs          = require 'fs'
csv         = require 'csv-parse'

paths =
  SCRIPTS_ENTRY: './assets/scripts/app.coffee'
  SCRIPTS_OUTPUT: 'bundle.js'
  DIST: './public'
  STYLES_ENTRY: './assets/styles/app.scss'

# This task converts CSV data into JSON
gulp.task 'data', (done) ->
  fs.readFile './data/data.csv', (err, file) ->
    $.util.log err.message if err?
    parseOpts =
      columns: true
      auto_parse: true
    csv file, parseOpts, (err, json) ->
      fs.writeFile './data/data.json', JSON.stringify(json), (err) ->
        $.util.log err.message if err?
        done()

gulp.task 'styles', ->
  gulp.src paths.STYLES_ENTRY
  .pipe $.sass
    includePaths: ['./node_modules']
    onError: (err) ->
      $.util.log 'Styles Error', err.message
  .pipe $.importCss()
  .pipe gulp.dest paths.DIST

# Watch files for changes and rebuild
gulp.task 'watch', ->

  gulp.watch ['./assets/styles/**/*.scss'], ['styles']

  bundler = watchify browserify(
    entries: [paths.SCRIPTS_ENTRY]
    extensions: ['.coffee', '.cjsx']
    transform: ['coffee-reactify']
    debug: true
    cache: {}
    packageCache: {}
    fullPaths: true
  )

  bundler.on 'update', ->
    @bundle()
    .pipe source paths.SCRIPTS_OUTPUT
    .pipe gulp.dest paths.DIST
    $.util.log "Bundle updated!"

  .bundle()
  .pipe source paths.SCRIPTS_OUTPUT
  .pipe gulp.dest paths.DIST

gulp.task 'dev', ['styles', 'watch']
