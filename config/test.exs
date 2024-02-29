import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :graceful_deploy, GracefulDeployWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "E+2c1F77dTuDfZCyyUAMmY3zH1iDYPtmr6lY0r86B449Gg9rcdqOBs9B/ulDXfIN",
  server: false

# In test we don't send emails.
config :graceful_deploy, GracefulDeploy.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
