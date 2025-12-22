defmodule Velora.Tenancy.Tenant do
  use Ecto.Schema
  @moduledoc false

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tenants" do
    field :name, :string
    field :slug, :string

    has_many :memberships, Velora.Tenancy.Membership

    timestamps()
  end
end
