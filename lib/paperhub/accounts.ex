defmodule Paperhub.Accounts do
  use Ash.Domain,
    otp_app: :paperhub

  resources do
    resource Paperhub.Accounts.Token
    resource Paperhub.Accounts.User
  end
end
