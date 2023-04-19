defmodule ApiMonitor.Handler do
  use GenServer
  alias ApiMonitor.MonitorDb
  alias ApiMonitor.Monitor

  @name :api_monitor_db

  def start_link(_args) do
    IO.inspect("Starting nmonitoring server.........")
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def init(state) do

    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    IO.inspect("ticking..........")
    state = MonitorDb.list_endpoint
    Monitor.call_endpoints(state)
    schedule_work()
    {:noreply, state}
  end

  def schedule_work() do
    Process.send_after(self(), :work, :timer.seconds(15))
  end


end
