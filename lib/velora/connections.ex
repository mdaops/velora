defmodule Velora.Connections do
  import Ecto.Query

  alias Velora.Repo
  alias Velora.Connections.Vcs

  def list_connections_by_tenant(tenant_id, opts \\ []) do
    from(Velora.Connections.Vcs, where: [tenant_id: ^tenant_id])
    |> Repo.all()
  end

  def get_connection_by_tenant_and_provider(tenant_id, provider, opts \\ []) do
    from(Velora.Connections.Vcs, where: [tenant_id: ^tenant_id, provider: ^provider])
    |> Repo.one()
  end

  @spec create_vcs_connection(Velora.Connections.Vcs.t()) ::
          {:ok, Velora.Connections.Vcs.t()} | {:error, Ecto.Changeset.t()}
  def create_vcs_connection(attrs \\ %{}) do
    %Velora.Connections.Vcs{}
    |> Velora.Connections.Vcs.register_changeset(attrs)
    |> Repo.insert()
  end

  def get_vcs_connection(id), do: Repo.get(Velora.Connections.Vcs, id)

  def establish_vcs_connection(connection_id, attrs \\ %{}) do
    case get_vcs_connection(connection_id) do
      %Velora.Connections.Vcs{} = conn ->
        conn
        |> Velora.Connections.Vcs.establish_changeset(attrs)
        |> Repo.update()

      nil ->
        {:error, :not_found}
    end
  end
end
