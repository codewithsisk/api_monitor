# EndpointMonitor

To start the server:

  * Run `mix setup` to install and setup dependencies
  * Run `mix ecto.create` to create database if it does not exist already
  * Run `mix ecto.migrate` to run database migration
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


## About the project

This project was created as a way to play around and test some of the features in Elixir and [Phoenix](https://www.phoenixframework.org/). Some of the key features that i used in this project include [GenServers](https://hexdocs.pm/elixir/GenServer.html) to manage state,  and also [Supervisor](https://hexdocs.pm/elixir/Supervisor.html) for fault-tolerance etc. 
One use case i tried to demostrate in this project is that of an endpoint monitoring application. It uses elixir [Process](https://hexdocs.pm/elixir/Process.html) to schedule health check on a given endpoint. I will dive deep on some of the features on my upcoming blog post coming soon.
