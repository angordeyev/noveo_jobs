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

**General approach**  
If the goal is to have the report mentioned in the previous task in real-time, the report should be build without evaluating all the data from the database but updated using incoming data only.  

**Incoming data processing**  
It is the first stage: a continent is calculated for each job offer, then it is passed to the report processing module. There is a fast function that calculates continent base on the roughly approximated continent regions on the map for the performance reasons. It will work well for most of the areas that can contain jobs. This process will multiply the performance if run in parallel processes.  

**Report processing**  
As the report has quite short data, the report data model is updated for each job or batch of jobs. Then it is written to the database so there is no need to recalculate the report if the system crashes. Report tables should be in sync with the job report tables.  
Visual representation of the report is rerendered using the whole data model. Thought, the current implementation contains server-side rendering, client rendering can save some server processor time. Phoenix WebSocket channels is a good choice to push updated report data to the client.  

**Database Storage**  
PostgreSQL will work well for 1000 writes per second as well for geospatial queries. Postponed database writing can be used to improve performance if there are some peaks with much more than 1000 writes per second (there can be a fast queue for data to write to a database, the system writes to this queue asynchronously and continuous operation without waiting for the data to be written to the actual database). Batch database writes can improve the performance. For fault tolerance, data can be written to a fail-safe message queue.  

**Fault tolerance**  
If we choose to use a queue, the job offers have to be saved to some fault-tolerant one before processing, so that in case of failure no jobs should be lost. RabbitMQ Highly Available (mirrored) queues could be used for that case.  

Report data and job data should be in sync to restore well from a crash. The report and job data tables should be updated in transactions.  

A database server should be replicated, a backup schedule should be created.  

**The current projects contains implementation in files:**  

[lib/noveo_jobs/professions_report.ex](https://github.com/angordeyev/noveo_jobs/blob/110ce8be7ba538a15d39c6a23a3a4d9d2159ec5f/lib/noveo_jobs/professions_report.ex#L2)  
[lib/noveo_jobs/geo_services.ex](https://github.com/angordeyev/noveo_jobs/blob/110ce8be7ba538a15d39c6a23a3a4d9d2159ec5f/lib/noveo_jobs/geo_services.ex#L2)  

**Modules:**  
[ProfessionsReport](https://github.com/angordeyev/noveo_jobs/blob/110ce8be7ba538a15d39c6a23a3a4d9d2159ec5f/lib/noveo_jobs/professions_report.ex#L2)  
[GeoServices](https://github.com/angordeyev/noveo_jobs/blob/110ce8be7ba538a15d39c6a23a3a4d9d2159ec5f/lib/noveo_jobs/geo_services.ex#L2)  


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