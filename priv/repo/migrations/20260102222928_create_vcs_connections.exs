defmodule Velora.Repo.Migrations.CreateVcsConnections do
  use Ecto.Migration

  def change do
    create table(:vcs_connections, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :installation_id, :string
      add :provider, :string
      add :status, :string

      add :tenant_id, references(:tenants, type: :binary_id)

      timestamps()
    end

    create index(:vcs_connections, [:installation_id])
    create index(:vcs_connections, [:tenant_id])
    create unique_index(:vcs_connections, [:tenant_id, :provider])
  end
end
