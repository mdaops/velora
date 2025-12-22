defmodule VeloraWeb.API.GithubWebhook do
  use VeloraWeb, :controller

  def create(conn, data) do
    IO.inspect(data)

    conn
    |> put_status(:no_content)
    |> json(%{
      "status" => "ok"
    })
  end
end
