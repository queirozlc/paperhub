defmodule Paperhub.AccountsTest do
  alias Paperhub.Accounts
  use Paperhub.DataCase, async: true

  describe "get_user/1" do
    test "should get an existing user" do
      user = generate(user())

      assert user_found = Accounts.get_user!(user.id)
      assert user_found.id == user.id
    end

    test "returns error not found when no user exists" do
      assert_raise Ash.Error.Query.NotFound, fn -> Accounts.get_user!(123) end
    end

    test "everyone should be able to get an user" do
      [user, other_user] = generate_many(user(), 2)
      assert true == Accounts.can_get_user?(user, other_user.id)
    end
  end

  describe "set_current_team/2" do
  end
end
