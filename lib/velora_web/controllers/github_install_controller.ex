defmodule VeloraWeb.GithubInstallController do
  use VeloraWeb, :controller
  require Logger

  @app_slug "velora-platform"

  def new(conn, params) do
    url =
      case params["org"] do
        nil ->
          "https://github.com/apps/#{@app_slug}/installations/new"

        "" ->
          "https://github.com/apps/#{@app_slug}/installations/new"

        org ->
          "https://github.com/organizations/#{URI.encode_www_form(org)}/settings/apps/#{@app_slug}/installations/new"
      end

    tenant_id = conn.assigns.current_tenant.id

    case Velora.Connections.create_vcs_connection(%{
           name: "GitHub",
           tenant_id: tenant_id,
           provider: :github
         }) do
      {:ok, connection} ->
        put_session(conn, :pending_github_connection, connection.id)
        redirect(conn, external: url)

      {:error, reason} ->
        Logger.info(tenant_id)
        Logger.error("Failed to create connection: #{reason}")
        conn
        |> put_flash(:error, "Failed to create connection")
        |> redirect(to: ~p"/dashboard")
    end
  end

  def callback(conn, params) do
    installation_id = params["installation_id"]
    # tenant_id = get_session(conn, :current_tenant)
    connection_id = get_session(conn, :pending_github_connection)

    attrs = %{
      installation_id: installation_id
    }

    case Velora.Connections.establish_vcs_connection(connection_id, attrs) do
      {:ok, _} ->
        delete_session(conn, :pending_github_connection)
        redirect(conn, to: ~p"/dashboard")

      {:error, _} ->
        conn
        |> put_flash(:error, "Failed to establish connection")
        |> redirect(to: ~p"/dashboard")
    end
  end
end
