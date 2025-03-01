defmodule PaperhubWeb.Router do
  use PaperhubWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PaperhubWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Inertia.Plug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PaperhubWeb do
    pipe_through [:browser]

    get "/onboarding", OnboardingController, :index
  end

  scope "/", PaperhubWeb do
    pipe_through [:browser]

    # get "/", PageController, :index
    # post "/projects", ProjectController, :create
    # get "/workspace/:public_id", ProjectController, :show
  end

  scope "/", PaperhubWeb do
    pipe_through [:browser]

    post "/magic_link/request", AuthController, :magic_link_request
    get "/login", AuthController, :new
    get "/verify-email", AuthController, :verify_email
  end

  # Other scopes may use custom stacks.
  # scope "/api", PaperhubWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:paperhub, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PaperhubWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
