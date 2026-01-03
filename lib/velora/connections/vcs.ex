defmodule Velora.Connections.Vcs do
  use Ecto.Schema
  import Ecto.Changeset
  @moduledoc false

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "vcs_connections" do
    field :name, :string
    field :installation_id, :string
    field :provider, Ecto.Enum, values: [:github], default: :github
    field :status, Ecto.Enum, values: [:connected, :disconnected], default: :disconnected

    belongs_to :tenant, Velora.Tenancy.Tenant

    timestamps()
  end

  def register_changeset(connection, params) do
    connection
    |> cast(params, [:name, :provider, :tenant_id])
    |> validate_required([:name, :provider, :tenant_id])
    |> put_change(:status, :disconnected)
  end

  def establish_changeset(connection, params) do
    connection
    |> cast(params, [:installation_id])
    |> validate_required([:installation_id])
    |> put_change(:status, :connected)
  end

  def disconnect_changeset(connection, params) do
    connection
    |> cast(params, [:connection_id, :tenant_id])
    |> validate_required([:connection_id, :tenant_id])
    |> put_change(:status, :disconnected)
  end
end
