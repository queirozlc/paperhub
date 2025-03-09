defmodule Paperhub.Accounts.User do
  use Ash.Resource,
    otp_app: :paperhub,
    domain: Paperhub.Accounts,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshAuthentication, AshJason.Resource],
    data_layer: AshPostgres.DataLayer

  authentication do
    add_ons do
      log_out_everywhere do
        apply_on_password_change?(true)
      end
    end

    tokens do
      enabled? true
      token_resource Paperhub.Accounts.Token
      signing_secret Paperhub.Secrets
      store_all_tokens? true
      require_token_presence_for_authentication? true
    end

    strategies do
      magic_link do
        identity_field :email
        registration_enabled? true
        single_use_token? true

        sender Paperhub.Accounts.User.Senders.SendMagicLinkEmail
      end
    end
  end

  postgres do
    table "users"
    repo Paperhub.Repo

    references do
      reference :current_team, index?: true
    end
  end

  code_interface do
    # This should no be used in the application
    # is just for testing and debugging purposes
    define :create, action: :create
  end

  actions do
    defaults [:read, create: [:email]]

    read :get_by_subject do
      description "Get a user by the subject claim in a JWT"
      argument :subject, :string, allow_nil?: false
      get? true
      prepare AshAuthentication.Preparations.FilterBySubject
    end

    read :get_by_email do
      description "Looks up a user by their email"
      get? true

      argument :email, :ci_string do
        allow_nil? false
      end

      filter expr(email == ^arg(:email))
    end

    create :sign_in_with_magic_link do
      description "Sign in or register a user with magic link."

      argument :token, :string do
        description "The token from the magic link that was sent to the user"
        allow_nil? false
      end

      upsert? true
      upsert_identity :unique_email
      upsert_fields [:email]

      # Uses the information from the token to create or sign in the user
      change AshAuthentication.Strategy.MagicLink.SignInChange

      metadata :token, :string do
        allow_nil? false
      end
    end

    action :request_magic_link do
      argument :email, :ci_string do
        allow_nil? false
      end

      run AshAuthentication.Strategy.MagicLink.Request
    end

    read :get_user do
      get? true
      argument :id, :integer, allow_nil?: false

      filter expr(id == ^arg(:id))
    end

    update :set_current_team do
      accept [:name]

      argument :team_id, :integer, allow_nil?: false
      change set_attribute(:current_team_id, arg(:team_id))
    end
  end

  policies do
    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      authorize_if always()
    end

    policy action([:get_user, :set_current_team]) do
      authorize_if always()
    end
  end

  attributes do
    integer_primary_key :id

    attribute :email, :ci_string do
      allow_nil? false
      public? true
    end

    attribute :name, :string, public?: true
    attribute :bio, :string, public?: true
    attribute :avatar, :string, public?: true

    timestamps()
  end

  relationships do
    belongs_to :current_team, Paperhub.Accounts.Team, allow_nil?: true
  end

  identities do
    identity :unique_email, [:email]
  end
end
