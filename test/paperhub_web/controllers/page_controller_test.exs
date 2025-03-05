defmodule PaperhubWeb.PageControllerTest do
  use PaperhubWeb.ConnCase, async: true
  import Paperhub.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  describe "GET /" do
    test "renders home page", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get(~p"/")
      assert inertia_props(conn) == %{projects: [], errors: %{}, flash: %{}, user: user}
      assert inertia_component(conn) == "Home"
    end
  end
end
