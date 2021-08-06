# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :tradiex_platform, TradiexPlatformWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Gabla39QICois/5qCqiWg1KGIac7UAa7zYF0M6FYGAmlBwoS+v6GfW3efmUJBRI6",
  render_errors: [view: TradiexPlatformWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TradiexPlatform.PubSub,
  live_view: [signing_salt: "yP832cJL"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library,  Jason

config :surface, :components, [
  {Surface.Components.Form.ErrorTag, default_translator: {MyAppWeb.ErrorHelpers, :translate_error}}
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
import_config "secret.exs"
