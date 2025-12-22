defmodule VeloraWeb.GithubAppManifestController do
  use VeloraWeb, :controller

  alias Velora.Github.AppManifest
  alias Velora.Github.Client

  def new(conn, params) do
    state = params["state"] || random_state()
    org = params["org"]

    conn = put_session(conn, :github_manifest_state, state)
    action_url = AppManifest.install_url(state, org)
    manifest_json = AppManifest.manifest_json()
    html = AppManifest.form_html(action_url, manifest_json)

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, html)
  end

  def callback(conn, %{"code" => code} = params) do
    state = params["state"]
    session_state = get_session(conn, :github_manifest_state)

    cond do
      session_state && state != session_state ->
        conn
        |> put_status(:unauthorized)
        |> json(%{"error" => "invalid_state"})

      true ->
        conn = delete_session(conn, :github_manifest_state)

        case Client.exchange_manifest(code) do
          {:ok, payload} ->
            json(conn, payload)

          {:error, reason} ->
            conn
            |> put_status(:bad_gateway)
            |> json(%{"error" => "exchange_failed", "detail" => inspect(reason)})
        end
    end
  end

  defp random_state do
    16
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64(padding: false)
  end
end
