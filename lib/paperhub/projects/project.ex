defmodule Paperhub.Projects.Project do
  require Ash.Resource.Change.Builtins

  use Ash.Resource,
    otp_app: :paperhub,
    domain: Paperhub.Projects,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJason.Resource]

  postgres do
    table "projects"
    repo Paperhub.Repo
  end

  actions do
    defaults [:read]

    create :create do
      accept [:title, :description]

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
end
