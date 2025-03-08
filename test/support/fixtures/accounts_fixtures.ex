defmodule Paperhub.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Paperhub.Accounts` context.
  """
  alias Paperhub.Organizations

  def unique_user_email, do: Faker.Internet.email()

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email()
    })
  end

  def user_fixture(attrs \\ %{}, opts \\ []) do
    with_team? = Keyword.get(opts, :with_team?, false)

    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Paperhub.Accounts.register_user()

    [default_team_name, _] = String.split(user.email, "@")

    if with_team? do
      {:ok, %{user: user}} =
        Organizations.create_team(%{name: default_team_name}, user, default_team?: true)

      user
    else
      user
    end
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
