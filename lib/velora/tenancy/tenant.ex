defmodule Velora.Tenancy.Tenant do
  use Ecto.Schema
  import Ecto.Changeset
  @moduledoc false

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tenants" do
    field :name, :string
    field :slug, :string

    has_many :memberships, Velora.Tenancy.Membership

    timestamps()
  end

  def changeset(tenant, attrs) do
    tenant
    |> cast(attrs, [:name, :slug])
    |> validate_length(:name, min: 3, max: 100)
    |> validate_required([:name, :slug])
  end
end
