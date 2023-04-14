defmodule ApiMonitor.Handler do
  use GenServer

  @name :api_monitor_db

  def start_link(_args) do
    IO.inspect "Starting nmonitoring server........."
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def init(_state) do
    state = read()
    {:ok, state}
  end

  def info(context, schema, plural) do
    GenServer.cast @name, {:info, context, schema, plural}
  end

  def  create_field(name, type) do
    GenServer.cast @name, {:create_field, name, type}
  end

  def delete_field(name) do
    GenServer.call @name, {:delete_field, name}
  end

  def status do
    GenServer.call @name, :status
  end

  def save do
    GenServer.call @name, :save
  end



  #Server
  def handle_cast({:info, context, schema, plural}, state) do
    new_state = Map.put(state, "context", context)
    |> Map.put("schema", schema)
    |> Map.put("plural", plural)

    {:noreply, new_state}
  end

  def handle_cast({:create_field, name, type}, state) do
    fields = field(Map.get(state, "fields"))
    fields = [ %{"name" => name, "type" => type} | fields]

    new_state = Map.put state, "fields", fields
    {:noreply, new_state}
  end

  def handle_call(:status,_from, state) do

    {:reply, state, state}
  end

  def handle_call(:save, _from, state) do
    result = state
    |>Poison.encode!
    |>write


    {:reply, result, state}
  end

  def handle_call({:delete_field, field_name}, _from, state) do
    new_fields = state
    |>Map.get("fields")
    |>Enum.reject(fn %{"name" => name, "type" => _} -> name == field_name end)

    new_state = Map.put state, "fields", new_fields
    {:reply, :ok, new_state}
  end

  def field(nil) do
    []
  end

  def field(array) do
    array
  end

  def read do
    with {:ok, file} <- File.read("lib/config.json"),
    {:ok, map} <- Poison.decode(file) do
      map
    else {:error, _} -> %{}

    end
  end

  def write(content) do
    IO.inspect content
    path = Path.absname "lib/config.json"
    with :ok <- File.write(path, content) do
      :ok
    else {:error, type} ->
      IO.inspect type
      :error
    end
  end


end
