defmodule PaperhubWeb.UserSessionControllerTest do
  use PaperhubWeb.ConnCase, async: true

  import Ecto.Query

  alias Paperhub.Repo
  alias Paperhub.{Accounts, Accounts.UserToken}
  import Paperhub.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  describe "GET /users/log_in" do
    test "renders log in page", %{conn: conn} do
      conn = get(conn, ~p"/login")
      assert inertia_component(conn) == "Login"
    end

    test "redirects if already logged in", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get(~p"/login")
      assert redirected_to(conn) == ~p"/"
    end
  end

  describe "POST /magic_link/request" do
    test "sends a magic link when user not exists", %{conn: conn} do
      email = Faker.Internet.email()
      conn = post(conn, ~p"/magic_link/request", %{"email" => email})
      # redirect to verify email with email param
      assert redirected_to(conn) == ~p"/verify_email/#{email}"
      assert Accounts.get_user_by_email(email).email == email
    end

    test "sends a magic link for an existing user", %{conn: conn, user: user} do
      conn = post(conn, ~p"/magic_link/request", %{"email" => user.email})
      assert redirected_to(conn) == ~p"/verify_email/#{user.email}"
      assert Accounts.get_user_by_email(user.email).email == user.email
    end

    test "returns error when tries to request link without email", %{conn: conn} do
      conn = post(conn, ~p"/magic_link/request", %{"email" => ""})
      assert inertia_component(conn) == "Login"
      assert inertia_props(conn) == %{errors: %{email: "can't be blank"}, flash: %{}}
    end
  end

  describe "GET /magic_link/sign_in/:token" do
    setup %{conn: conn, user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_magic_link_token(user, url)
        end)

      %{conn: conn, user: user, token: token}
    end

    test "returns an error if is a invalid token", %{conn: conn} do
      invalid_token = "oops, invalid token"
      conn = get(conn, ~p"/magic_link/sign_in/#{invalid_token}")
      assert redirected_to(conn) == ~p"/login"
      assert Phoenix.Flash.get(conn.assigns[:flash], :error) == "Invalid token."
    end

    test "login user when token is a valid token", %{conn: conn, token: token} do
      conn = get(conn, ~p"/magic_link/sign_in/#{token}")
      assert redirected_to(conn) == ~p"/onboarding"
      assert fetch_cookies(conn, signed: ["_paperhub_web_user_remember_me"])
    end

    test "returns an error if token is expired", %{conn: conn, token: token} do
      {1, nil} =
        from(
          ut in UserToken,
          update: [set: [inserted_at: ^~N[2020-01-01 00:00:00]]]
        )
        |> Repo.update_all([], skip_team_id: true)

      conn = get(conn, ~p"/magic_link/sign_in/#{token}")
      assert redirected_to(conn) == ~p"/login"
      assert Phoenix.Flash.get(conn.assigns[:flash], :error) == "Invalid token."
    end
  end

  describe "GET /verify_email/:email" do
    test "renders /verify_email with email as props", %{conn: conn, user: user} do
      conn = get(conn, ~p"/verify_email/#{user.email}")
      assert inertia_component(conn) == "VerifyEmail"

      assert inertia_props(conn) == %{errors: %{}, email: user.email, flash: %{}}
    end

    test "redirects when user's already logged in", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> get(~p"/verify_email/#{user.email}")
      assert redirected_to(conn) == ~p"/"
    end
  end

  describe "DELETE /users/log_out" do
    test "logs the user out", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> delete(~p"/users/log_out")
      assert redirected_to(conn) == ~p"/login"
      refute get_session(conn, :user_token)
    end

    test "does not allow if the user is not logged in", %{conn: conn} do
      conn = delete(conn, ~p"/users/log_out")
      assert redirected_to(conn) == ~p"/login"
      refute get_session(conn, :user_token)
    end
  end
end
