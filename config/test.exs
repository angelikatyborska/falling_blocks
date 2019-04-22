use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :falling_blocks, FallingBlocksWeb.Endpoint,
  http: [port: 4002],
  server: false,
  live_view: [
    signing_salt: "iIutYOnfMkDnPpK6rLctyhsXeGxn+dvr"
  ]

# Print only warnings and errors during test
config :logger, level: :warn
