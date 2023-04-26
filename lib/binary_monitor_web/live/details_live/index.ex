defmodule BinaryMonitorWeb.DetailsLive.Index do
  use BinaryMonitorWeb, :live_view
  alias BianryMonitor.Handler

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}), kv: %{}, key: nil, value: nil, data: [], url: "")}
  end

  def handle_event("validate", %{"key" => key, "value" => value, "url" => url}, socket) do
    {:noreply, assign(socket, key: key, value: value, url: url)}
  end

  def handle_event("header", _, socket) do
    kv = %{id: socket.assigns.key, key: socket.assigns.key, value: socket.assigns.value}

    IO.inspect(kv)
    {:noreply, assign(socket, data: [kv | socket.assigns.data])}
  end

  def handle_event("save", _, socket) do
    url = socket.assigns.url

    headers = socket.assigns.data
    data = %{"url" => url, "header" => headers}
    IO.inspect(data)
    Handler.create_field("endpoints", data)
    Handler.save()
    {:noreply, push_navigate(socket, to: "/")}
  end
end
