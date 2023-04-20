defmodule ApiMonitor.Repo.Migrations.CreateEndpoint do
  use Ecto.Migration

  def change do
    create table(:endpoint) do
      add :url, :string
      add :name, :string
      add :schedule, :string
      add :headers, {:array, :jsonb}, default: []
      add :params, {:array, :jsonb}, default: []
      timestamps()
    end
  end
end
