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

  def request(url, headers, params \\ %{}) do
    headers = header_key_value(headers)
    params = param_map(params)
    url = url <> params
    IO.inspect(url)
    res = HTTPoison.get(url, headers)
    # Phoenix.PubSub.broadcast(PubSub, "hello", {:message, res})
  end

  def response(response) do
    for x <- response do
      IO.inspect("result")
      IO.inspect(x)
    end
  end

  def header_key_value(header) do
    Enum.into(header, [], fn h -> {String.to_atom(h.header_key), h.header_value} end)
  end

  def param_map(params) do
    keyword = Enum.into(params, [], fn p -> {String.to_atom(p.param_key), p.param_value} end)
    map = Enum.into(keyword, %{})
    param = URI.encode_query(map)
    query(param)
  end

  def query("") do
    ""
  end

  def query(query) do
    "?" <> query
  end

  def subscribe do
    Phoenix.PubSub.subscribe(PubSub, "hello")
  end
end
