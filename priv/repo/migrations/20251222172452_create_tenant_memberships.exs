defmodule Velora.Repo.Migrations.CreateTenantMemberships do
  use Ecto.Migration

  def change do
    create table(:tenants, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :slug, :string

      timestamps()
    end

    create unique_index(:tenants, [:slug])

    create table(:tenant_memberships, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :role, :string, null: false

      add :tenant_id,
          references(
            :tenants,
            type: :binary_id,
            on_delete: :delete_all
          ),
          null: false

      add :user_id,
          references(
            :users,
            type: :binary_id,
            on_delete: :delete_all
          ),
          null: false

      timestamps()
    end

    create unique_index(:tenant_memberships, [:tenant_id, :user_id])
    create index(:tenant_memberships, [:tenant_id])
    create index(:tenant_memberships, [:user_id])

    create constraint(
             :tenant_memberships,
             :role_must_be_valid,
             check: "role IN ('owner','admin','member')"
           )
  end
end
