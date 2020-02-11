defmodule NoveoJobsWeb.JobsController do
  use NoveoJobsWeb, :controller

  def find_in_radius(conn, _params) do
    json conn, %{hello: "world"}
  end
end
