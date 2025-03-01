defmodule Paperhub.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Paperhub.DataCase, async: true`, although
  this option is not recommended for other databases.
  """
  alias Paperhub.Accounts.User
  alias AshAuthentication.{Info, Strategy, Strategy.MagicLink}
  alias Ecto.Adapters.SQL.Sandbox

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Paperhub.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Paperhub.DataCase
    end
  end

  setup tags do
    Paperhub.DataCase.setup_sandbox(tags)
    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  """
  def setup_sandbox(tags) do
    pid = Sandbox.start_owner!(Paperhub.Repo, shared: not tags[:async])
    on_exit(fn -> Sandbox.stop_owner(pid) end)
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  defp email, do: Faker.Internet.email()

  def build_user! do
    user =
      User
      |> Ash.Changeset.for_create(:create, %{"email" => email()})
      |> Ash.create!(authorize?: false)

    strategy = Info.strategy!(User, :magic_link)

    with {:ok, token} <- MagicLink.request_token_for(strategy, user),
         {:ok, signed_in_user} <- Strategy.action(strategy, :sign_in, %{"token" => token}) do
      signed_in_user
    else
      {:error, reason} -> raise "Failed to sign in user: #{inspect(reason)}"
    end
  end
end
