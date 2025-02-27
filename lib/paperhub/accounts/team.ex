defmodule Paperhub.Accounts.Team do
  alias Ash.{Changeset, Resource.Change.Context}

  use Ash.Resource,
    otp_app: :paperhub,
    domain: Paperhub.Accounts,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "teams"
    repo Paperhub.Repo

    references do
      reference :owner, on_delete: :delete
    end
  end

  code_interface do
    define :get_by_owner, action: :get_by_owner
  end

  actions do
    defaults [:read, :destroy]

    read :get_by_owner do
      description "Get a team by the owner"
      get? true
      filter expr(owner_id == ^actor(:id))
    end

    create :create do
      primary? true
      argument :name, :string

      change relate_actor(:owner)

      change before_action(fn changeset, %Context{actor: actor} ->
               # The default name for a team will be the owner's name
               # fallbacks to first part of the email if the name is not provided

               if Changeset.get_argument(changeset, :name) do
                 changeset
               else
                 default_team_name =
                   actor.name ||
                     actor.email
                     |> Ash.CiString.to_comparable_string()
                     |> String.split("@")
                     |> List.first()

                 Changeset.force_change_attribute(changeset, :name, default_team_name)
               end
             end)
    end
  end

  attributes do
    integer_primary_key :id
    attribute :name, :string, allow_nil?: false
  end

  relationships do
    belongs_to :owner, Paperhub.Accounts.User, allow_nil?: false

    many_to_many :members, Paperhub.Accounts.User do
      through Paperhub.Accounts.TeamMembership
      destination_attribute_on_join_resource :member_id
    end
  end
end
