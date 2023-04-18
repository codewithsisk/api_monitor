defmodule ApiMonitorWeb.SingleLive.Index do
  use ApiMonitorWeb, :live_view
  alias ApiMonitorWeb.HttpComponent.HttpComponent
  alias ApiMonitorWeb.FtpComponent.FtpComponent

  import ApiMonitorWeb.Response

  def mount(_param, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}), protocol: "http", response: nil, error: nil)}
  end

  def handle_event("validate", %{"protocol" => protocol}, socket) do
    {:noreply, assign(socket, protocol: protocol)}
  end

  def handle_event("close-alert", _, socket) do
    {:noreply, assign(socket, response: nil)}
  end

  def handle_event("close-error", _, socket) do
    {:noreply, assign(socket, error: nil)}
  end

  def handle_info({:message, {:ok, response}}, socket) do
    IO.inspect(response)
    {:noreply, assign(socket, response: response)}
  end

  def handle_info({:message, {:error, error}}, socket) do
    IO.inspect(error)
    {:noreply, assign(socket, error: error)}
  end
end
