defmodule BinaryMonitor.Handler do
  use GenServer
  alias BinaryMonitor.MonitorDb
  alias BinaryMonitor.Monitor

  @name :binary_monitor_db

  def start_link(_args) do
    IO.inspect("Starting nmonitoring server.........")
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def init(state) do
    # init_work()
    schedule_5_m_work()
    schedule_15_m_work()
    {:ok, state}
  end

  def handle_info(:work_5m, _state) do
    IO.inspect("5 minutes schedule..........")
    state = MonitorDb.get_endpoint_by_schedule(:T5M)
    Monitor.call_endpoints(state)
    schedule_5_m_work()
    {:noreply, state}
  end

  def handle_info(:work_15m, _state) do
    IO.inspect("15 minutes schedule..........")
    state = MonitorDb.get_endpoint_by_schedule(:T15M)
    Monitor.call_endpoints(state)
    schedule_15_m_work()
    {:noreply, state}
  end

  # def handle_info(:init, _state) do
  #   IO.inspect("Initial schedule..........")
  #   state = MonitorDb.list_endpoint()
  #   Monitor.call_endpoints(state)
  #   {:noreply, state}
  # end

  def schedule_5_m_work() do
    # MUNITES REDUCED FOR TESTING
    Process.send_after(self(), :work_5m, :timer.minutes(5))
  end

  def schedule_15_m_work() do
    # MUNITES REDUCED FOR TESTING
    Process.send_after(self(), :work_15m, :timer.minutes(15))
  end

  # def init_work do
  #   Process.send_after(self(), :init, :timer.seconds(5))
  # end
end
