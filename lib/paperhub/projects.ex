defmodule Paperhub.Projects do
  use Ash.Domain,
    otp_app: :paperhub

  resources do
    resource Paperhub.Projects.Project
    resource Paperhub.Projects.ProjectCollaborator
  end
end
