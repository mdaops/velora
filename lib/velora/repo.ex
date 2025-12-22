defmodule Velora.Repo do
  use Ecto.Repo,
    otp_app: :velora,
    adapter: Ecto.Adapters.Postgres
end
