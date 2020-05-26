defmodule Vincy.Repo do
  use Ecto.Repo,
    otp_app: :vincy,
    adapter: Ecto.Adapters.Postgres
end
