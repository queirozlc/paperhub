defmodule Paperhub.Projects.ProjectCollaborator do
  use Ash.Resource,
    otp_app: :paperhub,
    domain: Paperhub.Projects,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "project_collaborators"
    repo Paperhub.Repo

    references do
      reference :project, on_delete: :delete
      reference :collaborator, on_delete: :delete
    end
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  attributes do
    attribute :role, :atom do
      constraints one_of: [:editor, :viewer, :admin]
      public? true
    end
  end

  relationships do
    belongs_to :project, Paperhub.Projects.Project,
      primary_key?: true,
      allow_nil?: false

    belongs_to :collaborator, Paperhub.Accounts.User,
      primary_key?: true,
      allow_nil?: false
  end
end
