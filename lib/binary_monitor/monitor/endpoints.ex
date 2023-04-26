defmodule BinaryMonitor.Monitor.Endpoints do
  use Ecto.Schema
  import Ecto.Changeset

  schema "endpoint" do
    field(:name, :string)
    field(:url, :string)
    field(:schedule, Ecto.Enum, values: [:T5M, :T15M, :T30M, :T1H])
    embeds_many(:headers, BinaryMonitor.Monitor.Header, on_replace: :delete)
    embeds_many(:params, BinaryMonitor.Monitor.Param, on_replace: :delete)
    timestamps()
  end

  @doc false
  def changeset(endpoints, attrs) do
    endpoints
    |> cast(attrs, [:url, :name, :schedule])
    |> validate_required([:url, :name, :schedule])
    |> cast_embed(:headers)
    |> cast_embed(:params)
  end
end
