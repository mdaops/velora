defmodule Velora.Connections do
  import Ecto.Query

  alias Velora.Repo

  def list_connections_by_tenant(tenant_id, opts \\ []) do
    q = from(Velora.Connections.VCS, where: [tenant_id: ^tenant_id])
    q |> Repo.all()
  end

  def get_connection_by_tenant_and_provider(tenant_id, provider, opts \\ []) do
    from(Velora.Connections.VCS, where: [tenant_id: ^tenant_id, provider: ^provider])
    |> Repo.one()
  end

  @spec create_vcs_connection(Velora.Connections.VCS.t()) ::
          {:ok, Velora.Connections.VCS.t()} | {:error, Ecto.Changeset.t()}
  def create_vcs_connection(attrs \\ %{}) do
    %Velora.Connections.VCS{}
    |> Velora.Connections.VCS.register_changeset(attrs)
    |> Repo.insert()
  end

  def get_vcs_connection(id), do: Repo.get(Velora.Connections.VCS, id)

  def establish_vcs_connection(connection_id, attrs \\ %{}) do
    case get_vcs_connection(connection_id) do
      %Velora.Connections.VCS{} = conn ->
        conn |> Velora.Connections.VCS.establish_changeset(attrs) |> Repo.update()

      nil ->
        {:error, :not_found}
    end
  end
end
