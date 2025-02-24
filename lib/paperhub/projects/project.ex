defmodule Paperhub.Projects.Project do
  require Ash.Resource.Change.Builtins

  use Ash.Resource,
    otp_app: :paperhub,
    domain: Paperhub.Projects,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJason.Resource],
    authorizers: [Ash.Policy.Authorizer]

  alias Paperhub.Accounts.User
  alias Paperhub.Projects.ProjectCollaborator

  postgres do
    table "projects"
    repo Paperhub.Repo

    references do
      reference :owner, on_delete: :delete
    end
  end

  jason do
    pick(%{include: [:hash_id]})
  end

  actions do
    defaults [:read, :destroy]

    read :list_projects do
      filter expr(owner_id == ^actor(:id))

      prepare build(load: :hash_id)
    end

    create :create do
      primary? true
      change relate_actor(:owner)

      change before_action(fn changeset, _context ->
               # Put the default title as "Untitled Project" if the title is not provided
               Ash.Changeset.force_change_attribute(changeset, :title, "Untitled Project")
             end)

      change load :hash_id
    end
  end

  policies do
    policy action_type(:read) do
      description "Only admins can read everyone's projects"
      authorize_if expr(^actor(:admin) == true)
    end

    policy action(:list_projects) do
      description "The owner of the project must be present"
      authorize_if relates_to_actor_via(:owner)
    end

    policy action_type(:create) do
      authorize_if actor_present()
    end
  end

  attributes do
    integer_primary_key :id

    attribute :title, :string, public?: true
    attribute :description, :string, public?: true
    attribute :content, :map, public?: true
    attribute :slug, :string, public?: true

    timestamps()
  end

  relationships do
    belongs_to :owner, User, allow_nil?: false, writable?: true, attribute_type: :integer

    many_to_many :collaborators, User do
      through ProjectCollaborator
      source_attribute_on_join_resource :project_id
      destination_attribute_on_join_resource :collaborator_id
    end
  end

  calculations do
    calculate :hash_id, :string, Paperhub.Projects.Calculations.HashId
  end
end
