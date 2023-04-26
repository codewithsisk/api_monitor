defmodule BinaryMonitor.Monitor.Param do
  import Ecto.Changeset
  use Ecto.Schema

  embedded_schema do
    field(:param_key, :string)
    field(:param_value, :string)
  end

  def changeset(endpoint, params) do
    endpoint
    |> cast(params, [:param_key, :param_value])
  end
end
