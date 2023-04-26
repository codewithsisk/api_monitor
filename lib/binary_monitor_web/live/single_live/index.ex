defmodule BinaryMonitorWeb.SingleLive.Index do
  use BinaryMonitorWeb, :live_view
  alias BinaryMonitorWeb.HttpComponent.HttpComponent
  alias BinaryMonitorWeb.FtpComponent.FtpComponent

  def mount(_param, _session, socket) do
    {:ok,
     assign(socket,
       form: to_form(%{}),
       protocol: "http",
       checker_response: nil,
       checker_error: nil
     )}
  end

  def handle_event("validate", %{"protocol" => protocol}, socket) do
    {:noreply, assign(socket, protocol: protocol)}
  end

  def handle_event("close-alert", _, socket) do
    IO.inspect("close alert")
    {:noreply, assign(socket, checker_response: nil)}
  end

  def handle_event("close-error", _, socket) do
    {:noreply, assign(socket, checker_error: nil)}
  end

  # def handle_info({:message, {:ok, response}}, socket) do
  #   IO.inspect(response)
  #   {:noreply, assign(socket, checker_response: response)}
  # end

  # def handle_info({:message, {:error, error}}, socket) do
  #   IO.inspect(error)
  #   {:noreply, assign(socket, checker_error: error)}
  # end
end
