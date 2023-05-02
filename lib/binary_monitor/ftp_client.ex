defmodule BinaryMonitor.FtpClient do
  alias BinaryMonitor.FtpClient
  defstruct host: nil, username: nil, password: nil, port: nil

  def check(%FtpClient{port: ""} = client) do
    open(:ftp.open(client.host |> String.to_charlist), client)
  end

  def check(%FtpClient{port: port} = client) do
   
    case Integer.parse(port) do
      {num, _} -> open(:ftp.open(client.host |> String.to_charlist, port: num, timeout: 3_000), client)

      _ ->
    end
  end

  def open({:ok, pid}, client) do

    user(:ftp.user(pid, client.username |> String.to_charlist, client.password |> String.to_charlist))
  end

  def open(_error, _client) do

    {:error, "Connection failed"}
  end

  def user(:ok) do

    {:ok, "Connected succesfully"}
  end

  def user(_error) do

    {:error, "Invalid credentials"}
  end
end
