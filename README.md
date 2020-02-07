# TODO

- [ ] render function
- [x] Load file
- [x] Create phoenix application
- [x] Move to Phoenix
- [x] Supervisor
- [x] Run in parallel
- [ ] Remove unnecessary code
- [ ] Data structure for getting country from latitude and longitude
- [ ] Get Country
- [ ] Http requester
- [-] Get google api code
- [x] Get http library
- [x] Distance function
- [ ] Random coordinates generator
- [ ] Point in Geo Polygon 
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

# Starting

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

### Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
