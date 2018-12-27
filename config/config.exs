# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :remainder,
  ecto_repos: [Remainder.Repo]

# Configures the endpoint
config :remainder, RemainderWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hrBctUkg4TsZdL6YNerwDQl7iILZluTaaTuHPNyl/19a4yXPbWv/U4Tv7Z+nkx1/",
  render_errors: [view: RemainderWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Remainder.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# Configures Guardian
config :remainder, Remainder.Guardian,
       issuer: "remainder",
       secret_key: "xZIoAGskX2ryovfx88RLWcQ9/hVnxBPCOkYhFBRVkjU3l9IYyurJzow407cZZhRU"
