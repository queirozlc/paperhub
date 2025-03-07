defmodule Paperhub.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Paperhub.Organizations.{Member, Team}

  @type t :: %__MODULE__{
          id: integer(),
          email: String.t(),
          confirmed_at: DateTime.t(),
          name: String.t(),
          bio: String.t(),
          avatar: String.t(),
          admin?: boolean(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @derive {Jason.Encoder, only: [:id, :email, :name, :bio, :avatar, :admin?]}
  schema "users" do
    field :email, :string
    field :confirmed_at, :utc_datetime
    field :name, :string
    field :bio, :string
    field :avatar, :string
    field :admin?, :boolean, default: false
    has_many :teams, Paperhub.Organizations.Team, foreign_key: :owner_id

    many_to_many :memberships, Team,
      join_through: Member,
      on_delete: :delete_all,
      join_keys: [member_id: :id, team_id: :id],
      unique: true

    timestamps(type: :utc_datetime)
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of email.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour.

  ## Options

    * `:validate_email` - Validates the uniqueness of the email, in case
      you don't want to validate the uniqueness of the email (like when
      using this changeset for validations on a LiveView form before
      submitting the form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email])
    |> validate_email(opts)
  end

  defp validate_email(changeset, opts) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> maybe_validate_unique_email(opts)
  end

  defp maybe_validate_unique_email(changeset, opts) do
    if Keyword.get(opts, :validate_email, true) do
      changeset
      |> unsafe_validate_unique(:email, Paperhub.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email])
    |> validate_email(opts)
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    change(user, confirmed_at: now)
  end
end
