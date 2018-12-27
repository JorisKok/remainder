defmodule Remainder.Repo do
  use Ecto.Repo,
    otp_app: :remainder,
    adapter: Ecto.Adapters.Postgres
end
