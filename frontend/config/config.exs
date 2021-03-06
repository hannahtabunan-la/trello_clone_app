# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :frontend, FrontendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "k+n3rNFBanLRTyl182JmCMVOQaDdbP2OGyow0ywcqDDuuFgzLu+BUt28KqA3TN93",
  render_errors: [view: FrontendWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Frontend.PubSub,
  live_view: [signing_salt: "gtUBDVEOZ98xvIKeFN9BKD95EJXEx6Ff"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tesla, adapter: Tesla.Adapter.Hackney

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :frontend, FrontendWeb.Auth.Guardian,
  issuer: "frontend",
  secret_key: "3jGG1/wGTvm/XVm3NbaXzX4XxajSQUuktvzD4K77LgviFY8VQ+4+DQ8Z51v5VC3g"
