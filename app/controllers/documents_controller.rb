class DocumentsController < ApplicationController
  before_action :set_document_from_hash, only: %i[ show update destroy ]

  # GET /documents
  def index
    @documents = Document.all
    render inertia: "Document/Index", props: {
      documents: -> { @documents.map do |document|
          serialize_document(document)
        end
      },
      teams: -> { current_user.teams.includes(:cover_attachment).map do |team|
        serialize_team(team)
      end }
    }
  end

  # GET /documents/:sqid
  def show
    render inertia: "Document/Show", props: {
      document: -> { serialize_document(@document) }
    }
  end

  # POST /documents
  def create
    @document = Document.create!(document_params)
    redirect_to document_path(@document), notice: "document was successfully created."
  end

  # PATCH/PUT /documents/1
  def update
    @document.update!(document_params)
    redirect_to @document, notice: "Document was successfully updated."
  end

  # DELETE /documents/1
  def destroy
    @document.destroy!
    redirect_to documents_url, notice: "document was successfully destroyed."
  end

  # DELETE /documents
  def destroy_all
    Document.where(id: document_id_params).destroy_all
    redirect_to documents_url, notice: "documents were successfully destroyed."
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document_from_hash
      @document = Document.find_by_sqid!(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def document_params
      params.expect(document: [ :title, :description ])
    end

    def document_id_params
      params.expect(ids: [])
    end

    def serialize_document(document)
      document.as_json(methods: :sqid)
    end

    def serialize_team(team)
      team.as_json.merge("cover" => team_cover(team))
    end

    def team_cover(team)
      url_for(team.cover) if team.cover.attached?
    end
end
