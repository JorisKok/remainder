use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :remainder, RemainderWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :remainder, Remainder.Repo,
  username: "admin",
  password: "secret",
  database: "remainder_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# BCrypt speed for tests
config :bcrypt_elixir, :log_rounds, 4