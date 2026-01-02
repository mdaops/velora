defmodule VeloraWeb.API.GithubWebhook do
  use VeloraWeb, :controller

  def create(conn, data) do
    IO.inspect(data)
    tenant_id = get_session(conn, :current_tenant)

    conn
    |> put_status(:no_content)
    |> json(%{
      "status" => "ok"
    })
  end
end
