defmodule GracefulDeployWeb.PageLive do
  use GracefulDeployWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       count: 0,
       env_names: [
         "FLY_MACHINE_ID",
         "FLY_ALLOC_ID",
         "FLY_VM_MEMORY_MB",
         "FLY_APP_NAME",
         "FLY_PROCESS_GROUP",
         "FLY_PUBLIC_IP",
         "FLY_MACHINE_VERSION",
         "FLY_REGION",
         "PRIMARY_REGION",
         "FLY_IMAGE_REF"
       ]
     )}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div>
        <%= @count %><br>
        <.button phx-click="inc">+</.button>
        <.button phx-click="dec">-</.button>
      </div>

      <ul>
        <%= for env <- @env_names do %>
          <li>
            <strong><%= env %>:</strong>
            <%= System.get_env(env) %>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end

  def handle_event("inc", _params, socket) do
    {:noreply, assign(socket, :count, socket.assigns.count + 1)}
  end

  def handle_event("dec", _params, socket) do
    {:noreply, assign(socket, :count, socket.assigns.count - 1)}
  end
end
