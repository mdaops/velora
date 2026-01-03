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

    IO.inspect(conn.assigns)

    tenant_id = conn.assigns.current_tenant.id

    case Velora.Connections.create_vcs_connection(%{
           name: "GitHub",
           tenant_id: tenant_id,
           provider: :github
         }) do
      {:ok, connection} ->
        Logger.info("VCS connection created: #{connection.id}")

        conn
        |> put_session(:pending_github_connection, connection.id)
        |> redirect(external: url)

      {:error, reason} ->
        Logger.error("Failed to create VCS connection: #{inspect(reason)}")

        conn
        |> put_flash(:error, "Failed to create connection")
        |> redirect(to: ~p"/dashboard")
    end
  end

  def callback(conn, params) do
    installation_id = params["installation_id"]
    connection_id = get_session(conn, :pending_github_connection)

    Logger.info(
      "GitHub callback: installation_id=#{installation_id}, connection_id=#{connection_id}"
    )

    attrs = %{
      installation_id: installation_id
    }

    case Velora.Connections.establish_vcs_connection(connection_id, attrs) do
      {:ok, _} ->
        Logger.info("VCS connection established")

        conn
        |> delete_session(:pending_github_connection)
        |> redirect(to: ~p"/dashboard")

      {:error, reason} ->
        Logger.error("Failed to establish VCS connection: #{inspect(reason)}")
        conn
        |> put_flash(:error, "Failed to establish connection")
        |> redirect(to: ~p"/dashboard")
    end
  end

  defp build_github_url(nil), do: "https://github.com/apps/#{@app_slug}/installations/new"
  defp build_github_url(""), do: "https://github.com/apps/#{@app_slug}/installations/new"

  defp build_github_url(org),
    do:
      "https://github.com/organizations/#{URI.encode_www_form(org)}/settings/apps/#{@app_slug}/installations/new"
end
