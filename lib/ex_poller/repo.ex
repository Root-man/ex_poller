defmodule ExPoller.Repo do
  use Ecto.Repo,
    otp_app: :ex_poller,
    adapter: Ecto.Adapters.Postgres
end
