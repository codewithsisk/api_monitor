defmodule ApiMonitorWeb.MonitorLive.Index do
  use ApiMonitorWeb, :live_view

  alias ApiMonitor.Monitor
  import ApiMonitorWeb.CustomTable

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Monitor.subscribe()
      Monitor.all()
    end

    {:ok, assign(socket, form: %{url: ""}, data: [])}
  end

  def handle_event("validate", %{"url" => url}, socket) do
    IO.inspect(url)
    {:noreply, socket}
  end

  def handle_event("save", %{"url" => url}, socket) do
    spawn(fn -> Monitor.request(url) end)
    {:noreply, socket}
  end

  def handle_info({:message, {:ok, response}, point}, socket) do
    IO.inspect(response)
    info = %{info: point, status: response.status_code, time: DateTime.utc_now()}
    data = append_sort(socket.assigns.data, info)
    {:noreply, assign(socket, data: data)}
  end

  def handle_info({:message, {:error, error}, point}, socket) do
    IO.inspect(error)
    info = %{info: point, status: 500, time: DateTime.utc_now()}
    data = append_sort(socket.assigns.data, info)
    {:noreply, assign(socket, data: data)}
  end

  def append_sort(endpoints, point) do
    new_list = Enum.reject(endpoints, fn e -> e.info.id == point.info.id end)

    [point | new_list]
    |> Enum.sort(&(&1.status >= &2.status))
  end
end
