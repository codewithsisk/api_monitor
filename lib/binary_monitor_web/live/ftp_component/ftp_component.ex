defmodule BinaryMonitorWeb.FtpComponent.FtpComponent do
  use BinaryMonitorWeb, :live_component
  alias BinaryMonitor.FtpClient
  import BinaryMonitorWeb.Response

  def update(assigns, socket) do
    socket = assign(socket, assigns)

    {:ok,
     assign(socket,
       host: "",
       error: nil,
       response: nil,
       username: "",
       password: "",
       port: ""
     )}
  end

  def handle_event("validate", %{"host" => host, "username" => username, "password" => password, "port" => port}, socket) do

     {:noreply, assign(socket, error: nil, response: nil, username: username, password: password, port: port, host: host)}
  end

  def handle_event(
        "save",
        %{"host" => host, "username" => username, "password" => password, "port" => port},
        socket
      ) do

    client = %FtpClient{username: username, password: password, host: host, port: port}
    handle_client_response(FtpClient.check(client), socket)

  end

  def handle_client_response({:ok, message}, socket) do
    {:noreply, assign(socket, response: message)}
  end

  def handle_client_response({:error, message}, socket) do

    {:noreply, assign(socket, error: message)}
  end

  def handle_client_response(_, socket) do

    {:noreply, assign(socket, error: "Unkown error")}
  end

end
