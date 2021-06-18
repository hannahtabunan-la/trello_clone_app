defmodule FrontendWeb.Router do
  use FrontendWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {FrontendWeb.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :unauthenticated do
    plug FrontendWeb.Plugs.UnauthenticatedPipeline
  end

  scope "/", FrontendWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", FrontendWeb do
  #   pipe_through :api
  # end

  scope "/", FrontendWeb do
    pipe_through [:browser, :unauthenticated]

    get("/ping", PingController, :show)

    get "/signup", RegistrationController, :new
    post "/signup", RegistrationController, :create

    get "/signin", SessionController, :new
    post "/signin", SessionController, :create
  end

  # scope "/", FrontendWeb do
  #   pipe_through :browser

  #   post "/signup", AccountController, :create
  #   post "/signin", AccountController, :signin
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: FrontendWeb.Telemetry
    end
  end
end
