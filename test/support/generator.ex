defmodule Paperhub.Generator do
  @moduledoc "Data generation for tests"
  alias AshAuthentication.Strategy.MagicLink
  alias Paperhub.Accounts

  use Ash.Generator

  def user(opts \\ []) do
    # Get the magic link strategy
    strategy = AshAuthentication.Info.strategy!(Accounts.User, :magic_link)

    email = opts[:email] || Faker.Internet.email()

    {:ok, token} = MagicLink.request_token_for_identity(strategy, email)

    changeset_generator(Accounts.User, :sign_in_with_magic_link,
      defaults: [
        token: token
      ],
      overrides: opts
    )
  end
end
