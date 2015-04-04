gulp        = require 'gulp'
$           = do require 'gulp-load-plugins'
browserify  = require 'browserify'
watchify    = require 'watchify'
source      = require 'vinyl-source-stream'

paths =
  SCRIPTS_ENTRY: './assets/scripts/app.coffee'
  SCRIPTS_OUTPUT: 'bundle.js'
  DIST: './public'
  STYLES_ENTRY: './assets/styles/app.scss'

gulp.task 'styles', ->
  # $.rubySass paths.STYLES_ENTRY, loadPath: ['./public']
  # .on 'error', (err) ->
  #   $.util.log 'Error', err.message
  # .pipe gulp.dest paths.DIST
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
