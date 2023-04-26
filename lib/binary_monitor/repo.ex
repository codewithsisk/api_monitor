defmodule BinaryMonitor.Repo do
  use Ecto.Repo,
    otp_app: :binary_monitor,
    adapter: Ecto.Adapters.Postgres
end
