defmodule ApiMonitor.Monitor do
  alias ApiMonitor.Handler
  alias ApiMonitor.PubSub


  def check_all do
    Handler.status
    |> Map.get("endpoints")
    |> call_endpoints

  end

  def call_endpoints([]) do

  end

  def call_endpoints(endpoints) do
    endpoints
    |> Enum.map(fn %{"url" => e} -> spawn(fn -> request(e) end)end)
    |> response
  end

  def request(url) do
    res = HTTPoison.get(url)
    Phoenix.PubSub.broadcast(PubSub, "hello", {:message, res})
  end
  def response(response) do
    for x <- response do
      IO.inspect "result"
      IO.inspect x
    end
  end

  def subscribe do
    Phoenix.PubSub.subscribe(PubSub, "hello")
  end

end
