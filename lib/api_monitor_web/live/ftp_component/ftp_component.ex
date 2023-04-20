defmodule ApiMonitorWeb.FtpComponent.FtpComponent do
  use ApiMonitorWeb, :live_component

  def update(assigns, socket) do
    socket = assign(socket, assigns)

    {:ok,
     assign(socket,
       host: nil
     )}
  end

  def handle_event("validate", _, socket) do
    IO.inspect("validate")
    {:noreply, socket}
  end

  def handle_event(
        "save",
        %{"host" => host, "username" => username, "password" => password, "port" => port},
        socket
      ) do
    IO.inspect(host)
    IO.inspect(username)
    IO.inspect(password)
    IO.inspect(port)
    # TODO c
    {:noreply, socket}
  end
end
