# Up and running

**Prerequisites**
PostgreSQL with PostGIS plugin installed
The database should be accessable at localhost with the default credentials "login: postgres, password: postgres".

* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.setup`
* Install Node.js dependencies with `cd assets && npm install`
* Start Phoenix console `iex -S mix phx.server`

The application will be available at http://localhost:4000

# Tasks comments

## 01/03

The result can be seen at:
[http://localhost:4000](http://localhost:4000)

## 02/03

**The current projects contains implementation in files:**  
[lib/noveo_jobs/professions_report.ex](https://github.com/angordeyev/noveo_jobs/blob/110ce8be7ba538a15d39c6a23a3a4d9d2159ec5f/lib/noveo_jobs/professions_report.ex#L2)  
[lib/noveo_jobs/geo_services.ex](https://github.com/angordeyev/noveo_jobs/blob/110ce8be7ba538a15d39c6a23a3a4d9d2159ec5f/lib/noveo_jobs/geo_services.ex#L2)  

**Modules:**  
[ProfessionsReport](https://github.com/angordeyev/noveo_jobs/blob/110ce8be7ba538a15d39c6a23a3a4d9d2159ec5f/lib/noveo_jobs/professions_report.ex#L2)  
[GeoServices](https://github.com/angordeyev/noveo_jobs/blob/110ce8be7ba538a15d39c6a23a3a4d9d2159ec5f/lib/noveo_jobs/geo_services.ex#L2)  

There is a fast function that calculates continent base on the roughly approximated continent regions on the map, it will work well for the most of the areas that can have jobs.  

Then a job that contains continent and category is added to the report and report is recalculated.  

## 03/03

Code is available at:  
[lib/noveo_jobs_web/controllers/jobs_controller.ex](https://github.com/angordeyev/noveo_jobs/blob/110ce8be7ba538a15d39c6a23a3a4d9d2159ec5f/lib/noveo_jobs_web/controllers/jobs_controller.ex#L4) in function [NoveoJobsWeb.JobsController.find_in_radius/2](https://github.com/angordeyev/noveo_jobs/blob/110ce8be7ba538a15d39c6a23a3a4d9d2159ec5f/lib/noveo_jobs_web/controllers/jobs_controller.ex#L4)

API is available at:  
[http://localhost:4000/api/find-jobs-in-radius](http://localhost:4000/api/find-jobs-in-radius)

Example:  
[http://localhost:4000/api/find-jobs-in-radius?latitude=1&longitude=1&radius=10000](http://localhost:4000/api/find-jobs-in-radius?latitude=1&longitude=1&radius=10000)

# Approaches chosen:

1. Rough polygons used to detect continent, this approach is very fast and allows to do more then 80 000 operations per second on average machine

2. PostGIS is chosen to do calculations as a general approach, it supports spatial data indexes. R-Trees may be use with in-memory storage to boost performance, however the current solution allows to handle tens of thousands jobs per second

# Caveats

Postgres makes wrong calculation of radius and distances although the Postgres documentation about it is clear. It counts the distance between St.Petersburg and Moscow more than 800 kilometers.

Probably the performance may be increased if more parallel calculation will take place

More defence programming should be used to run in production

# TODO

- [x] fix tests 
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