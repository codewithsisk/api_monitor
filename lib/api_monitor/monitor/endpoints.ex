defmodule ApiMonitor.Monitor.Endpoints do
  use Ecto.Schema
  import Ecto.Changeset

  schema "endpoint" do
    field :name, :string
    field :url, :string
    embeds_many :headers, ApiMonitor.Monitor.Header, on_replace: :delete
    embeds_many :params, ApiMonitor.Monitor.Param , on_replace: :delete
    timestamps()
  end

  @doc false
  def changeset(endpoints, attrs) do
    endpoints
    |> cast(attrs, [:url, :name])
    |> validate_required([:url, :name])
    |> cast_embed(:headers)
    |> cast_embed(:params)
  end
end
