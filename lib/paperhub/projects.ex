defmodule Paperhub.Projects do
  use Ash.Domain,
    otp_app: :paperhub

  resources do
    resource Paperhub.Projects.Project do
      define :list_projects, action: :list_projects
      define :create_project, action: :create
    end
  end
end
