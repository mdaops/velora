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
          <.input field={@tenant_form[:slug]} label="Slug" required />
          <:actions>
            <.button phx-disable-with="creating...">Create Tenant</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:tenant_form, to_form(%{}, as: "tenant"))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("create", params, socket) do
    IO.inspect("fuck fuck")
    %{"tenant" => tenant_params} = params

    IO.inspect("tenant_params create #{inspect(tenant_params)}")
    user = socket.assigns.current_user

    case Velora.Tenancy.create_tenant_with_owner(user, tenant_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tenant created successfully.")
         |> redirect(to: ~p"/dashboard")}

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
