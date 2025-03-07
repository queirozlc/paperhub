defmodule PaperhubWeb.OnboardingController do
  use PaperhubWeb, :controller

  def index(conn, _params) do
    conn
    |> assign_prop(:user, conn.assigns.current_user)
    |> render_inertia("Onboarding")
  end
end
