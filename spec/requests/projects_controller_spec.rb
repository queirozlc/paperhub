RSpec.describe ProjectsController, :inertia do
  let(:project) { create(:blank_project) }

  before do
    sign_in project.team.owner, scope: :user
  end

  describe "GET #index" do
    it "renders a successful response" do
      get authenticated_root_url

      expect_inertia.to render_component("Project/Index").and include_props(
        projects: [ project.as_json(methods: :sqid) ]
      )
    end
  end

  describe "GET #show" do
    it "renders a successful response" do
      get project_url(project)
      expect_inertia.to render_component("Project/Show").and include_props(
        project: project.as_json(methods: :sqid)
      )
    end
  end

  describe "POST #create" do
    let(:valid_attributes) { {
      title: "New Project",
      description: "Project description"
    }}

    context "with valid parameters" do
      it "creates a new Project" do
        expect {
          post projects_url, params: { project: valid_attributes }
        }.to change(Project, :count).by(1)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {
          title: "Updated Project",
          description: "Updated description"
        }
      }

      it "updates the requested project" do
        expect {
        patch project_url(project), params: { project: new_attributes }
        project.reload
      }.to change(project, :title).to("Updated Project").and change(project, :description).to("Updated description")
      end

      it "redirects to the project" do
        patch project_url(project), params: { project: new_attributes }
        project.reload
        expect(response).to redirect_to(project_url(project))
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested project" do
      expect {
        delete project_url(project)
      }.to change(Project, :count).by(-1)
    end

    it "redirects to the projects list" do
      delete project_url(project)
      expect(response).to redirect_to(authenticated_root_url)
    end
  end

  describe "DELETE #destroy_all" do
    context "when multiple projects are present" do
      let(:projects) { create_list(:blank_project, 3, team: project.team) }

      it "destroys all requested projects" do
        projects
        expect {
          delete destroy_all_projects_url, params: { ids: projects.map(&:id) }
        }.to change(Project, :count).by(-3)
      end

      it "redirects to the projects list" do
        delete destroy_all_projects_url, params: { ids: projects.map(&:id) }
        expect(response).to redirect_to(authenticated_root_url)
      end
    end

    context "when no projects are present" do
      it "does not change the project count" do
        expect {
          delete destroy_all_projects_url, params: { ids: [] }
        }.not_to change(Project, :count)
      end

      it "redirects to the projects list" do
        delete destroy_all_projects_url, params: { ids: [] }
        expect(response).to redirect_to(authenticated_root_url)
      end
    end

    context "when at least one project is present" do
      it "performs a regular destroy" do
        expect {
          delete destroy_all_projects_url, params: { ids: [ project.id ] }
        }.to change(Project, :count).by(-1)
      end

      it "redirects to the projects list" do
        delete destroy_all_projects_url, params: { ids: [ project.id ] }
        expect(response).to redirect_to(authenticated_root_url)
      end
    end
  end
end
