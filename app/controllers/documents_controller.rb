class DocumentsController < ApplicationController
  before_action :set_document_from_hash, only: %i[ show update destroy ]

  # GET /documents
  def index
    @documents = Document.all
    render inertia: "Document/Index", props: {
      documents: -> { @documents.map { |document| document.as_json(methods: :sqid) } },
      active_team: -> { serialize_team(current_user.active_team) },
      teams: InertiaRails.optional { current_user.teams.where.not(id: current_user.active_team_id).with_attached_cover.map { |team| serialize_team(team) } },
      user_invitations: InertiaRails.optional { User.unscoped.unaccepted_invitations(current_user).map { |user| serialize_user_invitation(user) } },
      team_members: InertiaRails.optional do
        ActsAsTenant.without_tenant do
          User.with_role.with_team(current_user.active_team).where.not(id: current_user.id).map { |user| serialize_user_member(user) }
        end
      end
    }
  end

  # GET /documents/:sqid
  def show
    render inertia: "Document/Show", props: {
      document: -> { @document.as_json(methods: :sqid) }
    }
  end

  # POST /documents
  def create
    @document = Document.create!(document_params)
    @document.init_repository
    redirect_to document_path(@document), notice: "document was successfully created."
  end

  # PATCH/PUT /documents/1
  def update
    json_content = JSON.parse(document_params[:content]) if document_params[:content]

    params = if json_content.present?
      document_params.except(:content).merge(content: json_content)
    else
      document_params
    end

    @document.update!(params)

    redirect_to document_path(@document), notice: "document was successfully updated."
  end

  # DELETE /documents/1
  def destroy
    @document.destroy!
    redirect_to documents_url, notice: "document was successfully destroyed."
  end

  # DELETE /documents
  def destroy_all
    Document.includes(:team).where(id: document_id_params).destroy_all
    redirect_to documents_url, notice: "documents were successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document_from_hash
      @document = Document.find_by_sqid!(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def document_params
      # params.expect(document: %i[title description content])
      params.fetch(:document, {}).permit(%i[title description content])
    end

    def document_id_params
      params.expect(ids: [])
    end

    def serialize_team(team)
      team.as_json.merge("cover" => team_cover(team))
    end

    def team_cover(team)
      public_cdn_url(team.cover) if team.cover.attached?
    end

    def serialize_user_invitation(user)
      user.as_json(only: %i[id email name invitation_sent_at]).merge(avatar: user_avatar(user))
    end

    def serialize_user_member(user)
      user.as_json(only: %i[id email name role]).merge(avatar: user_avatar(user))
    end
end
