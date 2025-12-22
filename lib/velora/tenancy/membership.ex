defmodule Velora.Tenancy.Membership do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tenant_memberships" do
    field :role, Ecto.Enum, values: [:owner, :admin, :user]

    belongs_to :tenant, Velora.Tenancy.Tenant
    belongs_to :user, Velora.Accounts.User

    timestamps()
  end
end
