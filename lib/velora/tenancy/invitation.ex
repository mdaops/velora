defmodule Velora.Tenancy.Invitation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tenant_invitations" do
    field :token, :binary
    field :accepted_at, :naive_datetime
    field :expires_at, :naive_datetime
    field :role, Ecto.Enum, values: [:owner, :admin, :user]
    field :email, :string

    belongs_to :tenant, Velora.Tenancy.Tenant
    belongs_to :invited_by, Velora.Accounts.User

    timestamps()
  end

  def changeset(invitation, attrs) do
    invitation
    |> cast(attrs, [
      :token,
      :accepted_at,
      :expires_at,
      :role,
      :email,
      :invited_by_id,
      :tenant_id
    ])
    |> validate_required([
      :token,
      :accepted_at,
      :expires_at,
      :role,
      :email,
      :invited_by_id,
      :tenant_id
    ])
    |> foreign_key_constraint(:invited_by_id)
    |> foreign_key_constraint(:tenant_id)
  end
end
