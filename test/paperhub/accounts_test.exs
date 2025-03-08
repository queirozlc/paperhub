defmodule Paperhub.AccountsTest do
  use Paperhub.DataCase

  alias Paperhub.Accounts
  require Ecto.Query, warn: false

  import Paperhub.AccountsFixtures
  import Faker.Internet, only: [email: 0]
  alias Paperhub.Accounts.{User, UserToken}

  @skip_team_id skip_team_id: true

  describe "get_user_by_email/1" do
    test "does not return the user if the email does not exist" do
      refute Accounts.get_user_by_email("unknown@example.com")
    end

    test "returns the user if the email exists" do
      %{id: id} = user = user_fixture()
      assert %User{id: ^id} = Accounts.get_user_by_email(user.email)
    end
  end

  describe "get_user!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(-1)
      end
    end

    test "returns the user with the given id" do
      %{id: id} = user = user_fixture()
      assert %User{id: ^id} = Accounts.get_user!(user.id)
    end
  end

  describe "register_user/1" do
    test "requires email to be set" do
      {:error, changeset} = Accounts.register_user(%{})

      assert %{
               email: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates email when given" do
      {:error, changeset} = Accounts.register_user(%{email: "not valid"})

      assert %{
               email: ["must have the @ sign and no spaces"]
             } = errors_on(changeset)
    end

    test "validates maximum values for email for security" do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Accounts.register_user(%{email: too_long})
      assert "should be at most 160 character(s)" in errors_on(changeset).email
    end

    test "validates email uniqueness" do
      %{email: email} = user_fixture()
      {:error, changeset} = Accounts.register_user(%{email: email})
      assert "has already been taken" in errors_on(changeset).email

      # Now try with the upper cased email too, to check that email case is ignored.
      {:error, changeset} = Accounts.register_user(%{email: String.upcase(email)})
      assert "has already been taken" in errors_on(changeset).email
    end
  end

  describe "get_or_register/1" do
    test "returns the user when exists" do
      user = user_fixture()
      assert {:ok, same_user} = Accounts.get_or_register_user(%{"email" => user.email})
      assert same_user.id == user.id
    end

    test "registers user when not found" do
      email = email()
      refute %User{} == Accounts.get_user_by_email(email)
      assert {:ok, %User{} = new_user} = Accounts.get_or_register_user(%{"email" => email})
      assert new_user.id
    end

    test "returns error when email is not provided" do
      assert {:error, changeset} = Accounts.get_or_register_user(%{"email" => ""})

      assert %{
               email: ["can't be blank"]
             } = errors_on(changeset)
    end
  end

  describe "change_user_registration/2" do
    test "returns a changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_registration(%User{})
      assert changeset.required == [:email]
    end

    test "allows fields to be set" do
      email = unique_user_email()

      changeset =
        Accounts.change_user_registration(
          %User{},
          valid_user_attributes(email: email)
        )

      assert changeset.valid?
      assert get_change(changeset, :email) == email
    end
  end

  describe "change_user_email/2" do
    test "returns a user changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_email(%User{})
      assert changeset.required == [:email]
    end
  end

  describe "apply_user_email/3" do
    setup do
      %{user: user_fixture()}
    end

    test "requires email to change", %{user: user} do
      {:error, changeset} = Accounts.apply_user_email(user, %{})
      assert %{email: ["did not change"]} = errors_on(changeset)
    end

    test "validates email", %{user: user} do
      {:error, changeset} =
        Accounts.apply_user_email(user, %{email: "not valid"})

      assert %{email: ["must have the @ sign and no spaces"]} = errors_on(changeset)
    end

    test "validates maximum value for email for security", %{user: user} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Accounts.apply_user_email(user, %{email: too_long})

      assert "should be at most 160 character(s)" in errors_on(changeset).email
    end

    test "validates email uniqueness", %{user: user} do
      %{email: email} = user_fixture()

      {:error, changeset} = Accounts.apply_user_email(user, %{email: email})

      assert "has already been taken" in errors_on(changeset).email
    end

    test "applies the email without persisting it", %{user: user} do
      email = unique_user_email()
      {:ok, user} = Accounts.apply_user_email(user, %{email: email})
      assert user.email == email
      assert Accounts.get_user!(user.id).email != email
    end
  end

  describe "deliver_user_update_email_instructions/3" do
    setup do
      %{user: user_fixture()}
    end

    test "sends token through notification", %{user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_update_email_instructions(user, "current@example.com", url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)

      assert user_token =
               Repo.get_by(UserToken, %{token: :crypto.hash(:sha256, token)}, @skip_team_id)

      assert user_token.user_id == user.id
      assert user_token.sent_to == user.email
      assert user_token.context == "change:current@example.com"
    end
  end

  describe "update_user_email/2" do
    setup do
      user = user_fixture()
      email = unique_user_email()

      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_update_email_instructions(%{user | email: email}, user.email, url)
        end)

      %{user: user, token: token, email: email}
    end

    test "updates the email with a valid token", %{user: user, token: token, email: email} do
      assert Accounts.update_user_email(user, token) == :ok
      changed_user = Repo.get!(User, user.id, @skip_team_id)
      assert changed_user.email != user.email
      assert changed_user.email == email
      assert changed_user.confirmed_at
      assert changed_user.confirmed_at != user.confirmed_at
      refute Repo.get_by(UserToken, %{user_id: user.id}, @skip_team_id)
    end

    test "does not update email with invalid token", %{user: user} do
      assert Accounts.update_user_email(user, "oops") == :error
      assert Repo.get!(User, user.id, @skip_team_id).email == user.email
      assert Repo.get_by(UserToken, %{user_id: user.id}, @skip_team_id)
    end

    test "does not update email if user email changed", %{user: user, token: token} do
      assert Accounts.update_user_email(%{user | email: "current@example.com"}, token) == :error
      assert Repo.get!(User, user.id, @skip_team_id).email == user.email
      assert Repo.get_by(UserToken, %{user_id: user.id}, @skip_team_id)
    end

    test "does not update email if token expired", %{user: user, token: token} do
      {1, nil} =
        from(
          u in UserToken,
          update: [set: [inserted_at: ^~N[2020-01-01 00:00:00]]]
        )
        |> Repo.update_all([], skip_team_id: true)

      assert Accounts.update_user_email(user, token) == :error
      assert Repo.get!(User, user.id, @skip_team_id).email == user.email
      assert Repo.get_by(UserToken, %{user_id: user.id}, @skip_team_id)
    end
  end

  describe "generate_user_session_token/1" do
    setup do
      %{user: user_fixture()}
    end

    test "generates a token", %{user: user} do
      token = Accounts.generate_user_session_token(user)
      assert user_token = Repo.get_by(UserToken, %{token: token}, @skip_team_id)
      assert user_token.context == "session"

      # Creating the same token for another user should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%UserToken{
          token: user_token.token,
          user_id: user_fixture().id,
          context: "session"
        })
      end
    end
  end

  describe "get_user_by_session_token/1" do
    setup do
      user = user_fixture()
      token = Accounts.generate_user_session_token(user)
      %{user: user, token: token}
    end

    test "returns user by token", %{user: user, token: token} do
      assert session_user = Accounts.get_user_by_session_token(token)
      assert session_user.id == user.id
    end

    test "does not return user for invalid token" do
      refute Accounts.get_user_by_session_token("oops")
    end

    test "does not return user for expired token", %{token: token} do
      {1, nil} =
        from(
          u in UserToken,
          update: [set: [inserted_at: ^~N[2020-01-01 00:00:00]]]
        )
        |> Repo.update_all([], skip_team_id: true)

      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "delete_user_session_token/1" do
    test "deletes the token" do
      user = user_fixture()
      token = Accounts.generate_user_session_token(user)
      assert Accounts.delete_user_session_token(token) == :ok
      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "sign_in_with_magic_link/1" do
    setup do
      user = user_fixture()

      token =
        extract_user_token(fn url ->
          Accounts.deliver_magic_link_token(user, url)
        end)

      %{user: user, token: token}
    end

    test "logs user in with a valid token", %{user: user, token: token} do
      assert {:ok, signed_user} = Accounts.sign_in_magic_link(token)
      assert signed_user.confirmed_at
      assert signed_user.confirmed_at != user.confirmed_at
      assert Repo.get!(User, user.id, @skip_team_id).confirmed_at
      refute Repo.get_by(UserToken, %{user_id: user.id}, @skip_team_id)
    end

    test "does not login with invalid token", %{user: user} do
      assert Accounts.sign_in_magic_link("oops") == :error
      refute Repo.get!(User, user.id, @skip_team_id).confirmed_at
      assert Repo.get_by(UserToken, %{user_id: user.id}, @skip_team_id)
    end

    test "does not login email if token expired", %{user: user, token: token} do
      {1, nil} =
        from(
          u in UserToken,
          update: [set: [inserted_at: ^~N[2020-01-01 00:00:00]]]
        )
        |> Repo.update_all([], skip_team_id: true)

      assert Accounts.sign_in_magic_link(token) == :error
      refute Repo.get!(User, user.id, @skip_team_id).confirmed_at
      assert Repo.get_by(UserToken, %{user_id: user.id}, @skip_team_id)
    end
  end
end
