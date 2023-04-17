defmodule ApiMonitor.Monitor do
  alias ApiMonitor.Handler
  alias ApiMonitor.PubSub

  def check_all do
    Handler.status()
    |> Map.get("endpoints")
    |> call_endpoints
  end

  def call_endpoints([]) do
  end

  def call_endpoints(endpoints) do
    endpoints
    |> Enum.each(fn %{"url" => e, "header" => headers} -> spawn(fn -> request(e, headers) end) end)


  end

  def request(url, headers) do
    headers = header_key_value(headers)

    res = HTTPoison.get(url, headers)
    Phoenix.PubSub.broadcast(PubSub, "hello", {:message, res})
  end

  def response(response) do
    for x <- response do
      IO.inspect("result")
      IO.inspect(x)
    end
  end

  def header_key_value(header) do
    Enum.into(header, [], fn h -> {String.to_atom(h.key), h.value} end)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(PubSub, "hello")
  end
end
