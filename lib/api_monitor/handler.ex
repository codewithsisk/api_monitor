defmodule ApiMonitor.Handler do
  use GenServer

  @name :api_monitor_db

  def start_link(_args) do
    IO.inspect("Starting nmonitoring server.........")
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def init(_state) do
    state = read()
    {:ok, state}
  end

  def info(context, schema, plural) do
    GenServer.cast(@name, {:info, context, schema, plural})
  end

  def create_field(name, data) do
    GenServer.cast(@name, {:create_field, name, data})
  end

  def delete_field(name) do
    GenServer.call(@name, {:delete, name})
  end

  def status do
    GenServer.call(@name, :status)
  end

  def save do
    GenServer.call(@name, :save)
  end

  # Server
  def handle_cast({:info, context, schema, plural}, state) do
    new_state =
      Map.put(state, "context", context)
      |> Map.put("schema", schema)
      |> Map.put("plural", plural)

    {:noreply, new_state}
  end

  def handle_cast({:create_field, name, data}, state) do
    endpoints = field(Map.get(state, name))

    endpoints = [data | endpoints]

    new_state = Map.put(state, "endpoints", endpoints)
    {:noreply, new_state}
  end

  def handle_call(:status, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:save, _from, state) do
    result =
      state
      |> Poison.encode!()
      |> write

    {:reply, result, state}
  end

  def handle_call({:delete, field_name}, _from, state) do
    new_state =
      state
      |> Map.get("endpoints")
      |> Enum.reject(fn %{"url" => url} -> url == field_name end)

    new_state = Map.put(state, "endpoints", new_state)
    {:reply, new_state, new_state}
  end

  def field(nil) do
    []
  end

  def field(array) do
    array
  end

  def read do
    with {:ok, file} <- File.read("lib/endpoints.json"),
         {:ok, map} <- Poison.decode(file) do
      map
    else
      {:error, _} -> %{}
    end
  end

  def write(content) do
    path = Path.absname("lib/endpoints.json")

    with :ok <- File.write(path, content) do
      :ok
    else
      {:error, type} ->
        IO.inspect(type)
        :error
    end
  end
end
