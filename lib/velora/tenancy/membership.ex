defmodule Velora.Tenancy.Membership do
  use Ecto.Schema

  @primary_key false
  schema "memberships" do
    belongs_to :tenant, Velora.Tenancy.Tenant
    timestamps()
  end
end
