defmodule ApiMonitorWeb.MonitorLive.Index do
  use ApiMonitorWeb, :live_view

  alias ApiMonitor.Monitor


  def mount(_params, _session, socket) do
    if connected?(socket) do
      Monitor.subscribe()
      Monitor.check_all()
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

  def handle_info({:message, {:ok, response}}, socket) do
    IO.inspect(response)
    {:noreply, assign(socket, data: [response | socket.assigns.data])}
  end

  def handle_info({:message, {:error, error}}, socket) do
    IO.inspect(error)
    {:noreply, socket}
  end

end
