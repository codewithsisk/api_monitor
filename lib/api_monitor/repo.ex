defmodule ApiMonitor.Repo do
  use Ecto.Repo,
    otp_app: :api_monitor,
    adapter: Ecto.Adapters.Postgres
end
