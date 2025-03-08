defmodule PaperhubWeb.PageControllerTest do
  alias Paperhub.Accounts
  use PaperhubWeb.ConnCase, async: true
  import Paperhub.AccountsFixtures

  describe "GET /" do
    setup do
      user = user_fixture(%{}, with_team?: true)
      %{user: user}
    end

    test "renders home page", %{conn: conn, user: user} do
      user = Accounts.get_user!(user.id)
      conn = conn |> log_in_user(user) |> get(~p"/")
      assert inertia_props(conn) == %{projects: [], errors: %{}, flash: %{}, user: user}
      assert inertia_component(conn) == "Home"
    end
  end
end
