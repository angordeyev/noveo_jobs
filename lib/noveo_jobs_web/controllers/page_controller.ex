defmodule NoveoJobsWeb.PageController do
  use NoveoJobsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
