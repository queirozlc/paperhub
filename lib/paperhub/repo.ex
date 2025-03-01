defmodule Paperhub.Repo do
  use Ecto.Repo,
    otp_app: :paperhub,
    adapter: Ecto.Adapters.Postgres
end
