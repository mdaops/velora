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
          <h2 class="text-lg font-semibold text-zinc-900 mb-4">Quick Actions</h2>
          <div class="space-y-2">
            <.button class="w-full">Manage Settings</.button>
            <.button class="w-full">Invite Members</.button>
            <.button class="w-full">View Activity</.button>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    tenant = socket.assigns.tenant

    IO.inspect("tenant #{inspect(tenant)}")

    {:ok, socket}
  end
end
