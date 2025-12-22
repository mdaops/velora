defmodule VeloraWeb.TenantOnboardLive do
  use VeloraWeb, :live_view
  require Logger

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Tenant
      <:subtitle>Create a new tenant</:subtitle>
    </.header>

    <div class="space-y-12 divide-y">
      <div>
        <.simple_form
          for={@tenant_form}
          id="tenant_form"
          phx-submit="create"
          phx-change="validate"
        >
          <.input field={@tenant_form[:name]} label="Name" required />
          <:actions>
            <.button phx-disable-with="creating...">Create Tenant</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Velora.Tenancy.tenant_changeset(%Velora.Tenancy.Tenant{})

    socket =
      socket
      |> assign(:tenant_form, to_form(changeset, as: "tenant"))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("create", params, socket) do
    IO.inspect("fuck fuck")
    %{"tenant" => tenant_params} = params
    tenant_params = Map.put(tenant_params, "slug", tenant_params["name"])
    user = socket.assigns.current_user
    changeset = Velora.Tenancy.tenant_changeset(%Velora.Tenancy.Tenant{})

    case Velora.Tenancy.create_tenant_with_owner(user, tenant_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tenant created successfully.")
         |> assign(:tenant_form, changeset)}

      {:error, step, changeset, _} ->
        IO.inspect(step, label: "failed step")
        IO.inspect(changeset.errors, label: "changeset errors")
        {:noreply, assign(socket, :tenant_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate", %{"tenant" => tenant_params}, socket) do
    IO.inspect(tenant_params)

    tenant_form =
      %Velora.Tenancy.Tenant{}
      |> Velora.Tenancy.tenant_changeset(tenant_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, tenant_form: tenant_form)}
  end
end
