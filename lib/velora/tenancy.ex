defmodule Velora.Tenancy do
  import Ecto.Query

  alias Velora.Repo
  alias Velora.Tenancy.Membership

  @moduledoc """
  """

  def create_tenant(attrs \\ %{}) do
    %Velora.Tenancy.Tenant{}
    |> Velora.Tenancy.Tenant.changeset(attrs)
    |> Repo.insert()
  end

  def list_tenants(user_id, opts \\ []) do
    get_tenant_memberships_query_by_user(user_id)
    |> maybe_order(opts)
    |> Repo.all()
  end

  def invite_user(%Velora.Accounts.User{id: invited_by}, tenant, attrs \\ %{}) do
    attrs =
      attrs
      |> Map.put(:invited_by, invited_by)
      |> Map.put(:tenant, tenant)

    %Velora.Tenancy.Invitation{}
    |> Velora.Tenancy.Invitation.changeset(attrs)
    |> Repo.insert()
  end

  defp maybe_order(query, %{order_by: order_by}) do
    order_by(query, ^order_by)
  end

  defp maybe_order(query, _opts), do: query

  defp get_tenant_memberships_query_by_user(id) do
    from Membership, where: [user_id: ^id]
  end
end
