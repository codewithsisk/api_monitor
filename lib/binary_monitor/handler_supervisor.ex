defmodule BinaryMonitor.HandlerSupervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    children = [
      BinaryMonitor.Handler
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
