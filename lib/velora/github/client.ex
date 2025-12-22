defmodule Velora.Github.Client do
  @moduledoc false

  @config_key :github_app_manifest
  @github_api "https://api.github.com"

  def exchange_manifest(code) when is_binary(code) do
    url = "#{@github_api}/app-manifests/#{code}/conversions"

    headers =
      [
        {"accept", "application/vnd.github+json"},
        {"user-agent", "velora"}
      ]
      |> maybe_add_auth()

    request = Finch.build(:post, url, headers, "")

    case Finch.request(request, Velora.Finch) do
      {:ok, %Finch.Response{status: status, body: body}} when status in 200..299 ->
        Jason.decode(body)

      {:ok, %Finch.Response{status: status, body: body}} ->
        {:error, %{status: status, body: body}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp maybe_add_auth(headers) do
    case Application.get_env(:velora, @config_key, [])[:exchange_token] do
      nil -> headers
      token -> [{"authorization", "Bearer #{token}"} | headers]
    end
  end
end
