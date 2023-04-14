defmodule ApiMonitorWeb.MonitorLive.Index do
  use ApiMonitorWeb, :live_view

  alias ApiMonitor.Monitor


  def mount(_params, _session, socket) do
    if connected?(socket) do
      Monitor.subscribe()
    end
    {:ok, assign(socket, form: %{url: ""}, data: [])}
  end


  def handle_event("validate", %{"url" => url}, socket) do
    IO.inspect url
    {:noreply, socket}
  end

  def handle_event("save", %{"url" => url}, socket) do
    IO.inspect "saving"
    IO.inspect url
    spawn(fn -> Monitor.request(url) end)
    {:noreply, socket}
  end


  def handle_info({:message, {:ok, response}}, socket) do
    IO.inspect "Message recieved"
    IO.inspect response
    {:noreply, assign(socket, data: [response | socket.assigns.data])}
  end

  end
