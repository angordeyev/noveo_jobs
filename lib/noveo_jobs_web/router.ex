defmodule NoveoJobsWeb.Router do
  use NoveoJobsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NoveoJobsWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/find-in-radius", FindInRadiusController, :find_in_radius
  end

  scope "/api", NoveoJobsWeb do
    pipe_through :api
    get "/find-jobs-in-radius", JobsController, :find_in_radius
  end



  # Other scopes may use custom stacks.
  # scope "/api", NoveoJobsWeb do
  #   pipe_through :api
  # end
end
