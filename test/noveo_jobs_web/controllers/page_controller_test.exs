defmodule NoveoJobsWeb.PageControllerTest do
  use NoveoJobsWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Jobs"
  end

end
