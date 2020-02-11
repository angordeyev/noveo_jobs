defmodule NoveoJobsWeb.JobsController do
  use NoveoJobsWeb, :controller

  def find_in_radius(conn, %{"latitude" => latitude, "longitude" => longitude, "radius" => radius}) do
    {radius, _} = Float.parse(radius)
    radius = radius * 1000
    get_rows = fn(%Postgrex.Result{rows: rows}) -> rows end
    # To use the database most efficiently, it is best to do radius queries which combine the radius test with a bounding box test:
    # the bounding box test uses the spatial index, giving fast access to a subset of data which the radius test is then applied to.
    # The ST_DWithin(geometry, geometry, distance) function is a handy way of performing an indexed distance search. It works by
    # creating a search rectangle large enough to enclose the distance radius, then performing an exact distance search on the
    # indexed subset of results.
    # ST_DWithin works incorrectly for some reason, probably some database setting, could not fix in short perios
    # ST_Distance also does not work correctly, checked on the distance between St. Petersburg and Moscow
    # Usage http://localhost:4000/api/find-jobs-in-radius?latitude=1&longitude=1&radius=1000000
    # TODO: Protect from SQL injections
    {:ok, query_result} = NoveoJobs.Repo.query("SELECT id, name, ST_Distance(location, 'POINT(#{latitude} #{longitude})') FROM jobs WHERE ST_DWithin(location, 'POINT(#{latitude} #{longitude})', #{radius})")
    rows =
      get_rows.(query_result)
      |> Enum.map(fn [id, name, distance] -> %{id: id, name: name, distance: distance/1000} end)
    json conn, rows
  end
end


