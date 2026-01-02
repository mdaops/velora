defmodule VeloraWeb.DashboardLive do
  use VeloraWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-4xl">
      <.header class="mb-8">
        Dashboard
        <:subtitle>Welcome to your tenant</:subtitle>
      </.header>

      <div class="grid gap-6 md:grid-cols-2">
        <div class="rounded-lg border border-zinc-200 p-6">
          <h2 class="text-lg font-semibold text-zinc-900 mb-4">Your Tenant</h2>
          <div class="space-y-2">
            <p><strong>Name:</strong> {@tenant.name}</p>
            <p><strong>Slug:</strong> {@tenant.slug}</p>
          </div>
        </div>

        <div class="rounded-lg border border-zinc-200 p-6">
          <h2 class="text-lg font-semibold text-zinc-900 mb-4">Connections</h2>
          <div class="space-y-4">
            <div class="flex items-center justify-between">
              <div class="flex items-center gap-3">
                <div class="flex h-10 w-10 items-center justify-center rounded-full bg-zinc-100">
                  <svg class="h-5 w-5 text-zinc-700" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z" />
                  </svg>
                </div>
                <div>
                  <p class="font-medium text-zinc-900">GitHub</p>
                  <p :if={@github_connected} class="text-sm text-zinc-500">Connected</p>
                  <p :if={!@github_connected} class="text-sm text-zinc-500">Not connected</p>
                </div>
              </div>
              <.button phx-click={show_modal("github-connect-modal")}>
                {if(@github_connected, do: "Manage", else: "Connect")}
              </.button>
            </div>
          </div>
        </div>

        <div class="rounded-lg border border-zinc-200 p-6 md:col-span-2">
          <h2 class="text-lg font-semibold text-zinc-900 mb-4">Quick Actions</h2>
          <div class="space-y-2">
            <.button class="w-full">Manage Settings</.button>
            <.button class="w-full">Invite Members</.button>
            <.button class="w-full">View Activity</.button>
          </div>
        </div>
      </div>

      <.modal id="github-connect-modal" on_cancel={hide_modal("github-connect-modal")}>
        <:title>Connect GitHub</:title>
        <:subtitle>
          Install the Velora GitHub App to enable version control integration.
        </:subtitle>

        <div class="py-4">
          <p class="text-sm text-zinc-600 mb-4">
            You'll be redirected to GitHub to install the app. Select the repositories
            you want to connect to your tenant.
          </p>

          <div class="flex items-center gap-3 p-4 bg-zinc-50 rounded-lg">
            <svg class="h-8 w-8 text-zinc-700" viewBox="0 0 24 24" fill="currentColor">
              <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z" />
            </svg>
            <div>
              <p class="font-medium text-zinc-900">Velora Platform</p>
              <p class="text-sm text-zinc-500">Read and write access to repositories</p>
            </div>
          </div>
        </div>

        <:confirm>
          <.button phx-click="connect_github">
            Connect GitHub
          </.button>
        </:confirm>
        <:cancel>
          <.button phx-click={hide_modal("github-connect-modal")}>
            Cancel
          </.button>
        </:cancel>
      </.modal>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    tenant = socket.assigns.tenant
    # TODO: Check if tenant has GitHub connection
    github_connected = false

    {:ok, assign(socket, github_connected: github_connected)}
  end

  def handle_event("connect_github", _params, socket) do
    {:noreply,
     socket
     |> push_event("open_github_window", %{
       url: ~p"/github/connect"
     })}
  end
end
