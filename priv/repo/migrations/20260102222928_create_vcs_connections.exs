defmodule Velora.Repo.Migrations.CreateVcsConnections do
  use Ecto.Migration

  def change do
    create table(:tenants_vcs_connections) do
      add :name, :string
      add :installation_id, :string
      add :provider, :string
      add :status, :string

      add :tenant_id, references(:tenants, type: :binary_id)

      timestamps()
    end

    add unique_index(:tenants_vcs_connections, [:tenant_id, :provider])
  end
end
