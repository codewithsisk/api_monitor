defmodule ApiMonitorWeb.HttpComponent.HttpComponent do
  use ApiMonitorWeb, :live_component
  alias ApiMonitor.Monitor
  alias ApiMonitor.MonitorDb

  def update(assigns, socket) do
    socket = assign(socket, assigns)

    {:ok,
     assign(socket,
       kv: %{},
       header_key: nil,
       header_value: nil,
       headers: [],
       url: "",
       name: nil,
       params: [],
       param_key: nil,
       param_value: nil
     )}
  end

  def handle_event(
        "validate",
        %{
          "header_key" => key,
          "header_value" => value,
          "url" => url,
          "name" => name,
          "param_key" => p_key,
          "param_value" => p_value
        },
        socket
      ) do
    IO.inspect("validating HTTP")

    {:noreply,
     assign(socket,
       header_key: key,
       header_value: value,
       url: url,
       name: name,
       param_key: p_key,
       param_value: p_value
     )}
  end

  def handle_event("header", _, socket) do
    header = %{
      id: socket.assigns.header_key,
      header_key: socket.assigns.header_key,
      header_value: socket.assigns.header_value
    }

    IO.inspect(header)
    {:noreply, assign(socket, headers: [header | socket.assigns.headers])}
  end

  def handle_event("param", _, socket) do
    IO.inspect("headers")
    param = %{param_key: socket.assigns.param_key, param_value: socket.assigns.param_value}

    IO.inspect(param)
    {:noreply, assign(socket, params: [param | socket.assigns.params])}
  end

  def handle_event("save", _, socket) do
    url = socket.assigns.url
    headers = convert_list(socket.assigns.headers)
    params = convert_list(socket.assigns.params)
    name = socket.assigns.name
    data = %{"url" => url, "name" => name, "headers" => headers, "params" => params}

    res = MonitorDb.create_endpoints(data)
    IO.inspect(res)
    maybe_redirect(socket, res)
    # response = Monitor.request(url, headers, params)
    # notify_parent({:message, response})

  end

  def maybe_redirect(socket, {:ok, _endpoint}) do
    {:noreply, push_navigate(socket, to: "/")}
  end

  def maybe_redirect(socket, _any) do
    {:noreply, assign(socket, error: "Error")}
  end

  def convert_list(list) do
    Enum.map(list, fn item -> to_string_key(item) end)
  end
  def to_string_key(map) do
    Map.new(map, fn {k, v} -> {to_string(k), v} end)
  end

  defp notify_parent(msg), do: send(self(), msg)
  # def handle_event("save", _, socket) do
  #   url = socket.assigns.url

  #   headers = socket.assigns.data
  #   data = %{"url"=> url, "header" => headers}
  #   IO.inspect data
  #   Handler.create_field "endpoints", data
  #   Handler.save
  #   {:noreply, push_navigate(socket, to: "/")}
  # end
end
