defmodule Velora.Tenancy.Tenant do
  use Ecto.Schema
  @moduledoc false

  @primary_key false
  schema "tenants" do
    field :id, :binary_id
    field :name, :string
    field :slug, :string

    timestamps()
  end
end
