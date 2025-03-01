defmodule PaperhubWeb.Router do
  use PaperhubWeb, :router

  import PaperhubWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PaperhubWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug Inertia.Plug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  ## Authentication routes

  scope "/", PaperhubWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/login", UserSessionController, :new
    post "/magic_link/request", UserSessionController, :magic_link_request
    post "/users/log_in", UserSessionController, :create
  end

  scope "/", PaperhubWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/", PageController, :index
    delete "/users/log_out", UserSessionController, :delete
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
