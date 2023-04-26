defmodule BinaryMonitor.Monitor.Header do
  import Ecto.Changeset
  use Ecto.Schema

  embedded_schema do
    field(:header_key, :string)
    field(:header_value, :string)
  end

  def changeset(endpoint, params) do
    endpoint
    |> cast(params, [:header_key, :header_value])
  end
end
