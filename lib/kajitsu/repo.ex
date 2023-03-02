defmodule Kajitsu.Repo do
  use Ecto.Repo,
    otp_app: :kajitsu,
    adapter: Ecto.Adapters.Postgres
end
