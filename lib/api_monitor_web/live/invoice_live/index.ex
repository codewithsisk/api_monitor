defmodule ApiMonitorWeb.MonitorLive.Index do
  use ApiMonitorWeb, :live_view

  alias ApiMonitor.Monitor


  def mount(_params, _session, socket) do
    if connected?(socket) do
      Monitor.subscribe()
    end
    {:ok, socket}
  end


  def handle_info({:message, payload}, socket) do
    IO.inspect "Message recieved"
    IO.inspect payload
    {:noreply, socket}
  end

  end
