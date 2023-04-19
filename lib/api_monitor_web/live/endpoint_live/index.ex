defmodule ApiMonitorWeb.EndpointLive.Index do
  use ApiMonitorWeb, :live_view
  alias ApiMonitor.MonitorDb

  alias ApiMonitor.Handler

  def mount(_param, _session, socket) do
    endpoints = Handler.status()
    endpoints = endpoints(Map.get(endpoints, "endpoints"))
    IO.inspect(endpoints)
    {:ok, assign(socket, endpoints: endpoints)}
  end

  def handle_event("delete", %{"url" => url}, socket) do
    endpoints = Handler.delete_field(url)
    endpoints = endpoints(Map.get(endpoints, "endpoints"))
    Handler.save()
    {:noreply, assign(socket, endpoints: endpoints)}
  end

  def endpoints(nil), do: []

  def endpoints(data) do
    data
  end
end
