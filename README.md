# Parking Lot

A web app that visualizes parking lot data.

# Installation

To run, you'll need node/io.js installed on the host machine.

1. Clone this repo &mdash; `git clone https://github.com/TylerLH/parkinglot.git`
2. From the project directory, install dependencies &mdash; `npm install`
3. Run the server &mdash; `npm run start`
4. Open the client app in your browser (http://localhost:3000)

# Development

Follow the installation instructions above. Use `npm run dev` to run the development server (restarts on changes), and `gulp dev` to watch & build the client app when files change.

## Development Notes

- The server is written in Node using the Express.js framework.
- The client-side application is built using React and bundled with browserify. Builds are done using Gulp. The chart functionality is built with d3 + Rickshaw.

## Known Issues
- SVG rendering is a bit slow when plotting more than ~500 data points at a time, causing the UI to feel a bit sluggish when they're all visible. This can be resolved with a little more work using better rendering logic (perhaps using something like crossfilter.js, or putting together a smarter loading mechanism that responds to interaction with the graph).
