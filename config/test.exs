use Mix.Config

# Configure your database
# config :noveo_jobs, NoveoJobs.Repo,
#   username: "postgres",
#   password: "postgres",
#   database: "noveo_jobs_test",
#   hostname: "localhost",
#   pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :noveo_jobs, NoveoJobsWeb.Endpoint,
  http: [port: 4002],
  server: false


# Print only warnings and errors during test
config :logger, level: :warn


# Configure your database
config :noveo_jobs, NoveoJobs.Repo,
  username: "postgres",
  password: "postgres",
  database: "noveo_jobs_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10


config :noveo_jobs, NoveoJobs.Repo,
    pool: Ecto.Adapters.SQL.Sandbox