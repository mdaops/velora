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

  def tenant_changeset(tenant, attrs \\ %{}) do
    Velora.Tenancy.Tenant.changeset(tenant, attrs)
  end

  def get(id), do: Repo.get(Tenant, id)

  @doc """
  Creates a tenant with an owner.
  """
  @spec create_tenant_with_owner(Velora.Accounts.User.t(), map()) ::
          {:ok, Velora.Tenancy.Tenant.t()} | {:error, Ecto.Changeset.t()}
  def create_tenant_with_owner(%Velora.Accounts.User{id: user_id}, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :tenant,
      Velora.Tenancy.Tenant.changeset(%Velora.Tenancy.Tenant{}, attrs)
    )
    |> Ecto.Multi.insert(
      :membership,
      fn %{tenant: tenant} ->
        Velora.Tenancy.Membership.owner_changeset(%Velora.Tenancy.Membership{}, %{
          tenant_id: tenant.id,
          user_id: user_id
        })
      end
    )
    |> Repo.transaction()
  end

  @doc """
  Lists tenant memberships for a given user.
  """
  def list_tenants(user_id, opts \\ []) do
    get_tenant_memberships_query_by_user(user_id)
    |> maybe_order(opts)
    |> Repo.all()
  end

  def list_memberships_by_tenant(tenant_id, opts \\ []) do
    q = from m in Membership, where: [tenant_id: ^tenant_id]
    q = if preload = opts[:preload], do: preload(q, ^preload), else: q
    q |> maybe_order(opts) |> Repo.all()
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

  def user_has_membership?(user_id) do
    from(m in Membership, where: [user_id: ^user_id])
    |> Repo.exists?()
  end

  defp maybe_order(query, %{order_by: order_by}) do
    order_by(query, ^order_by)
  end

  defp maybe_order(query, _opts), do: query

  defp get_tenant_memberships_query_by_user(id) do
    from Membership, where: [user_id: ^id]
  end
end
