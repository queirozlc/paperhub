defmodule Paperhub.Projects.Project do
  require Ash.Resource.Change.Builtins

  use Ash.Resource,
    otp_app: :paperhub,
    domain: Paperhub.Projects,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJason.Resource]

  alias Paperhub.Accounts.User
  alias Paperhub.Projects.ProjectCollaborator

  postgres do
    table "projects"
    repo Paperhub.Repo

    references do
      reference :owner, on_delete: :delete
    end
  end

  actions do
    defaults [:read]

    create :create do
      accept [:title, :description]

      change relate_actor(:owner)

      change Paperhub.Projects.Changes.Slugify
    end
  end

  attributes do
    integer_primary_key :id

    attribute :title, :string do
      allow_nil? false
      public? true
    end

    attribute :description, :string do
      public? true
    end

    attribute :content, :string do
      public? true
    end

    attribute :slug, :string do
      allow_nil? false
      public? true
    end

    timestamps()
  end

  relationships do
    belongs_to :owner, User, allow_nil?: false, writable?: true

    many_to_many :collaborators, User do
      through ProjectCollaborator
      source_attribute_on_join_resource :project_id
      destination_attribute_on_join_resource :collaborator_id
    end
  end
end
