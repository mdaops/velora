defmodule Velora.Connections.VCS do
  use Ecto.Schema
  import Ecto.Changeset
  @moduledoc false

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "tenants_vcs_connection" do
    field :name, :string
    field :installation_id, :string
    field :provider, Ecto.Enum, values: [:github], default: :github
    field :status, Ecto.Enum, values: [:connected, :disconnected], default: :disconnected

    belongs_to :tenant, Velora.Tenancy.Tenant

    timestamps()
  end

  def register_changeset(connection, params) do
    connection
    |> cast(params, [:name, :provider, :status, :tenant_id])
    |> validate_required([:name, :provider, :status, :tenant_id])
  end

  def instantiate_connection_changeset(connection, params) do
    connection
    |> cast(params, [:installation_id, :tenant_id])
    |> validate_required([:installation_id, :tenant_id])
    |> put_change(:status, :connected)
  end
end
