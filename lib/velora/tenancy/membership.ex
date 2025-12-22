defmodule Velora.Tenancy.Membership do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tenant_memberships" do
    field :role, Ecto.Enum, values: [:owner, :admin, :user]

    belongs_to :tenant, Velora.Tenancy.Tenant
    belongs_to :user, Velora.Accounts.User

    timestamps()
  end

  def changeset(membership, attrs) do
    membership
    |> cast(attrs, [:role, :tenant_id, :user_id])
    |> validate_required([:role, :tenant_id, :user_id])
  end

  def owner_changeset(membership, attrs) do
    membership
    |> cast(attrs, [:tenant_id, :user_id])
    |> validate_required([:tenant_id, :user_id])
    |> put_change(:role, :owner)
  end
end
