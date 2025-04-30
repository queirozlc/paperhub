class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show update destroy ]

  # GET /projects
  def index
    @projects = Project.all
    render inertia: "Project/Index", props: {
      projects: @projects.map do |project|
        serialize_project(project)
      end,
      teams: current_user.teams.map do |team|
        serialize_team(team)
      end
    }
  end

  # GET /projects/1
  def show
    render inertia: "Project/Show", props: {
      project: serialize_project(@project)
    }
  end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to authenticated_root_path, notice: "Project was successfully created."
    else
      redirect_to new_project_url, inertia: { errors: @project.errors }
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      redirect_to @project, notice: "Project was successfully updated."
    else
      redirect_to edit_project_url(@project), inertia: { errors: @project.errors }
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy!
    redirect_to authenticated_root_url, notice: "Project was successfully destroyed."
  end

  # DELETE /projects
  def destroy_all
    Project.where(id: project_id_params).destroy_all
    redirect_to authenticated_root_url, notice: "Projects were successfully destroyed."
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.expect(project: [ :title, :description ])
    end

    def project_id_params
      params.expect(ids: [])
    end

    def serialize_project(project)
      project.as_json
    end

    def serialize_team(team)
      team.as_json.merge("cover" => team.cover_url)
    end
end
