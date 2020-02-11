# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :noveo_jobs,
  ecto_repos: [NoveoJobs.Repo]

config :noveo_jobs, NoveoJobs.Repo,
  types: NoveoJobs.PostgrexTypes


# Configures the endpoint
config :noveo_jobs, NoveoJobsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fo0pztWruHg+5uxpc9THwfTsKhDRA1NCxaEJcTkvyfQZQ2WAG5pGhZSsDmivO3iL",
  render_errors: [view: NoveoJobsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: NoveoJobs.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
