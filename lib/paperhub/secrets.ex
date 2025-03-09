defmodule Paperhub.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], Paperhub.Accounts.User, _opts) do
    Application.fetch_env(:paperhub, :token_signing_secret)
  end
end
