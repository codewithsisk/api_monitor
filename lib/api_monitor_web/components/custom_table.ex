defmodule ApiMonitorWeb.CustomTable do
  use Phoenix.Component

  attr :data, :list, required: true

  def route_table(assigns) do
    ~H"""
    <tbody class="divide-y divide-gray-200 bg-white">
      <%= for item <- @data do %>
        <tr>
          <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium sm:pl-6">
            <%= item.info.name %>
          </td>
          <td class="whitespace-nowrap px-3 py-4 text-sm"><%= item.info.url %></td>
          <td class="whitespace-nowrap px-3 py-4 text-sm">
            <%= item.time %>
          </td>

          <td class="whitespace-nowrap px-3 py-4 text-sm">
            <div class="flex items-center justify-end gap-x-2 sm:justify-start">
              <div class={"flex-none rounded-full p-1 #{get_color(item.status)}  bg-green-400/10"}>
                <div class="h-1.5 w-1.5 rounded-full bg-current"></div>
              </div>
              <div class="hidden sm:block">
                <%= item.status %>
              </div>
            </div>
          </td>
        </tr>
      <% end %>
    </tbody>
    """
  end

  def get_color(code) do
    if code >= 200 && code < 300, do: "text-green-400", else: "text-red-600"
  end
end
