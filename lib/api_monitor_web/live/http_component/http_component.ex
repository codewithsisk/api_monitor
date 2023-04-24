defmodule ApiMonitorWeb.HttpComponent.HttpComponent do
  use ApiMonitorWeb, :live_component
  alias ApiMonitor.Monitor
  alias ApiMonitor.MonitorDb
  import ApiMonitorWeb.Response

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
       param_value: nil,
       checker_error: nil,
       checker_response: nil,
       schedule: "T5M"
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
          "param_value" => p_value,
          "schedule" => schedule
        },
        socket
      ) do
    {:noreply,
     assign(socket,
       header_key: key,
       header_value: value,
       url: url,
       name: name,
       param_key: p_key,
       param_value: p_value,
       schedule: schedule,
       checker_error: nil,
       checker_response: nil
     )}
  end

  def handle_event("add-header", _, socket) do
    case Enum.find(socket.assigns.headers, fn h -> h.id == socket.assigns.header_key end) do
      nil ->
        header = %{
          id: socket.assigns.header_key,
          header_key: socket.assigns.header_key,
          header_value: socket.assigns.header_value
        }

        {:noreply, assign(socket, headers: [header | socket.assigns.headers])}

      item ->
        headers =
          Enum.map(socket.assigns.headers, fn h ->
            if h.id == item.id,
              do: Map.put(h, :header_value, socket.assigns.header_value),
              else: h
          end)

        IO.inspect(headers)
        {:noreply, assign(socket, headers: headers)}
    end
  end

  def handle_event("add-param", _, socket) do
    case Enum.find(socket.assigns.params, fn p -> p.id == socket.assigns.param_key end) do
      nil ->
        param = %{
          id: socket.assigns.param_key,
          param_key: socket.assigns.param_key,
          param_value: socket.assigns.param_value
        }

        {:noreply, assign(socket, params: [param | socket.assigns.params])}

      item ->
        params =
          Enum.map(socket.assigns.params, fn p ->
            if p.id == item.id, do: Map.put(p, :param_value, socket.assigns.param_value), else: p
          end)

        IO.inspect(params)
        {:noreply, assign(socket, params: params)}
    end
  end

  def handle_event("save", _, socket) do
    url = socket.assigns.url
    headers = convert_list(socket.assigns.headers)
    params = convert_list(socket.assigns.params)
    name = socket.assigns.name
    interval = socket.assigns.schedule

    data = %{
      "url" => url,
      "name" => name,
      "headers" => headers,
      "params" => params,
      "schedule" => interval
    }

    res = MonitorDb.create_endpoints(data)
    IO.inspect(res)
    maybe_redirect(socket, res)
    # response = Monitor.request(url, headers, params)
    # notify_parent({:message, response})
  end

  def handle_event("check", _, socket) do
    url = socket.assigns.url
    headers = socket.assigns.headers
    params = socket.assigns.params
    response = Monitor.validate(url, headers, params)
    handle_checker(response, socket)
  end

  def handle_event("delete-header", %{"header_id" => id}, socket) do
    headers = handle_delete(socket.assigns.headers, id)
    {:noreply, assign(socket, headers: headers)}
  end

  def handle_event("delete-param", %{"param_id" => id}, socket) do
    params = handle_delete(socket.assigns.params, id)

    {:noreply, assign(socket, params: params)}
  end

  def handle_checker({:ok, response}, socket) do
    IO.inspect(response)
    {:noreply, assign(socket, checker_response: response)}
  end

  def handle_checker({:error, error}, socket) do
    {:noreply, assign(socket, checker_error: error)}
  end

  def maybe_redirect(socket, {:ok, _endpoint}) do
    {:noreply, push_navigate(socket, to: "/")}
  end

  def maybe_redirect(socket, _any) do
    {:noreply, assign(socket, error: "Error")}
  end

  def handle_delete(list, id) do
    Enum.reject(list, fn h -> h.id == id end)
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
