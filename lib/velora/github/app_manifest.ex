defmodule Velora.Github.AppManifest do
  @moduledoc false

  @config_key :github_app_manifest

  def manifest(overrides \\ %{}) do
    config = Application.get_env(:velora, @config_key, [])
    base_url = config[:base_url] || VeloraWeb.Endpoint.url()

    hook_path = config[:hook_path] || "/api/github/events"
    redirect_path = config[:redirect_path] || "/github/app/manifest/callback"
    setup_path = config[:setup_url]

    manifest =
      %{
        "name" => config[:name] || "Velora",
        "url" => config[:url] || base_url,
        "hook_attributes" => %{
          "url" => build_url(base_url, hook_path),
          "active" => config[:hook_active] != false
        },
        "setup_url" => setup_path,
        "redirect_url" => build_url(base_url, redirect_path),
        "description" => config[:description] || "Velora GitHub App",
        "public" => config[:public] || false,
        "default_events" => config[:default_events] || ["push"],
        "default_permissions" =>
          config[:default_permissions] || %{"contents" => "read", "metadata" => "read"}
      }
      |> maybe_put("callback_urls", config[:callback_urls])
      |> maybe_put("setup_url", config[:setup_url])
      |> maybe_put("request_oauth_on_install", config[:request_oauth_on_install])
      |> maybe_put("setup_on_update", config[:setup_on_update])

    Map.merge(manifest, overrides)
  end

  def manifest_json(overrides \\ %{}) do
    manifest(overrides)
    |> Jason.encode!()
  end

  def install_url(state, nil) do
    query = URI.encode_query(%{"state" => state})
    "https://github.com/settings/apps/new?#{query}"
  end

  def install_url(state, org) do
    query = URI.encode_query(%{"state" => state})
    org = URI.encode_www_form(org)
    "https://github.com/organizations/#{org}/settings/apps/new?#{query}"
  end

  def form_html(action_url, manifest_json) do
    escaped_manifest =
      manifest_json
      |> Phoenix.HTML.html_escape()
      |> Phoenix.HTML.safe_to_string()

    """
    <!doctype html>
    <html lang="en">
    <head>
      <meta charset="utf-8" />
      <title>Register GitHub App</title>
    </head>
    <body>
      <form id="manifest-form" action="#{action_url}" method="post">
        <input type="hidden" name="manifest" value="#{escaped_manifest}" />
        <noscript>
          <button type="submit">Register GitHub App</button>
        </noscript>
      </form>
      <script>
        document.getElementById("manifest-form").submit();
      </script>
    </body>
    </html>
    """
  end

  defp build_url(base_url, path) do
    base_url
    |> String.trim_trailing("/")
    |> Kernel.<>(path)
  end

  defp maybe_put(map, _key, nil), do: map
  defp maybe_put(map, _key, []), do: map
  defp maybe_put(map, key, value), do: Map.put(map, key, value)
end
