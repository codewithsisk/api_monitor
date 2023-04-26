defmodule BinaryMonitorWeb.EndpointLive.Index do
  use BinaryMonitorWeb, :live_view
  alias BinaryMonitor.MonitorDb

  def mount(_param, _session, socket) do
    endpoints = MonitorDb.list_endpoint()
    IO.inspect(endpoints)
    {:ok, assign(socket, endpoints: endpoints)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    point = MonitorDb.get_endpoints(id)
    handle_delete(MonitorDb.delete_endpoints(point), socket)
  end

  def handle_delete({:ok, _}, socket) do
    {:noreply, push_navigate(socket, to: "/manage")}
  end

  def handle_delete(_, socket) do
    {:noreply, socket}
  end

  def endpoints(nil), do: []

  def endpoints(data) do
    data
  end
end
