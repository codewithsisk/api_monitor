defmodule BinaryMonitorWeb.Router do
  use BinaryMonitorWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BinaryMonitorWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BinaryMonitorWeb do
    pipe_through :browser

    #get "/", PageController, :home

    live "/", MonitorLive.Index, :index
    # live "/save", DetailsLive.Index, :index
    live "/manage", EndpointLive.Index, :index
    live "/endpoint", SingleLive.Index, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", BinaryMonitorWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:binary_monitor, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BinaryMonitorWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
