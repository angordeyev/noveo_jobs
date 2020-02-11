# Up and running

**Prerequisites**
PostgreSQL with PostGIS plugin installed
The database should be accessable at localhost with the default credentials "login: postgres, password: postgres".

Get the dependencies:

mix deps.get

Run the following commands to create the database:

mix ecto.setup

To start the application:

iex -S mix phx.server

The application will be available at http://localhost:4000

# TODO

- [ ] Remove unnecessary code
- [x] insert geographic into database
- [x] load csv to database
- [x] run custom query ecto
- [x] pass parameters
- [x] return from custom query (return all jobs)
- [x] dumb rest point
- [x] posgres, query in radius
- [x] insert geo data
- [x] convert latitude longitude to geography
- [x] create table with geo data
- [x] add postgress
- [x] jobs generator
- [x] fix table headers
- [x] javascript refresh page every second
- [x] show data on the page
- [x] Filling the data structure
- [-] autoupdate table on the page without blink
- [x] visualize table on page
- [x] render function
- [x] Load file
- [x] Create phoenix application
- [x] Move to Phoenix
- [x] Supervisor
- [x] Run in parallel
- [-] Get Country
- [-] Http requester
- [-] Get google api code
- [x] Get http library
- [x] Distance function
- [x] Random coordinates generator
- [-] Point in Geo Polygon 
- [-] Data structure for getting country from latitude and longitude
- [x] Create continent polygons
- [x] Create function to detetect continent from point
- [x] Convert polygons from Stackoverflow
- [x] Continent coordinates to separate file


# Approaches R3 

# Calculating distance

[52.5075419, 13.4251364]

Geocalc.distance_between([52.5075419, 13.4251364], [52.5075419, 23.4251364]) # in meters

# Calculating if point in continent

point = [14.952242, 60.1696017]
poly = [[24.950899, 60.169158], [24.953492, 60.169158], [24.953510, 60.170104], [24.950958, 60.169990]]
Geocalc.within?(poly, point)