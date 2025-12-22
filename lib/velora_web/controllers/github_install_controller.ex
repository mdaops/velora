defmodule VeloraWeb.GithubInstallController do
  use VeloraWeb, :controller

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

    redirect(conn, external: url)
  end

  def callback(conn, params) do
    IO.inspect(params)
    # TODO: retrieve tenant id from something like session
    # look up tenant vcs connection and update status with installation id
    # if successful, redirect to tenant page
    installation_id = params["installation_id"]

    conn
  end
end
