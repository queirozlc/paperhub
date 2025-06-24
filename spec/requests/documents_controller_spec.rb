RSpec.describe DocumentsController, :inertia do
  let(:document) { create(:blank_document) }

  before do
    sign_in document.team.owner, scope: :user
  end

  describe "GET #index" do
    context "without search parameter" do
      it "renders a successful response" do
        get authenticated_root_url

        expect_inertia.to render_component("Document/Index").and include_props(
          documents: [ document.as_json(methods: :sqid) ]
        )
      end
    end

    context "with search parameter" do
      let!(:matching_document) { create(:blank_document, title: "Test Document", team: document.team) }

      it "renders filtered documents based on search" do
        get authenticated_root_url, params: { search: "Test" }

        expect_inertia.to render_component("Document/Index").and include_props(
          documents: [ matching_document.as_json(methods: :sqid) ]
        )
      end

      it "renders all documents when search does not match" do
        get authenticated_root_url, params: { search: "NonExistent" }

        expect_inertia.to render_component("Document/Index").and include_props(
          documents: []
        )
      end

      it "performs case insensitive search" do
        get authenticated_root_url, params: { search: "test" }

        expect_inertia.to render_component("Document/Index").and include_props(
          documents: [ matching_document.as_json(methods: :sqid) ]
        )
      end
    end
  end

  describe "GET #show" do
    it "renders a successful response" do
      get document_url(document)
      expect_inertia.to render_component("Document/Show").and include_props(
        document: document.as_json(methods: :sqid)
      )
    end
  end

  describe "POST #create" do
    let(:valid_attributes) { {
      title: "New Document",
      description: "Document description"
    }}

    context "with valid parameters" do
      it "creates a new Document" do
        expect {
          post documents_url, params: { document: valid_attributes }
        }.to change(Document, :count).by(1)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {
          title: "Updated Document",
          description: "Updated description"
        }
      }

      it "updates the requested document" do
        expect {
        patch document_url(document), params: { document: new_attributes }
        document.reload
      }.to change(document, :title).to("Updated Document").and change(document, :description).to("Updated description")
      end

      it "redirects to the document" do
        patch document_url(document), params: { document: new_attributes }
        document.reload
        expect(response).to redirect_to(document_url(document))
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested document" do
      expect {
        delete document_url(document)
      }.to change(Document, :count).by(-1)
    end

    it "redirects to the documents list" do
      delete document_url(document)
      expect(response).to redirect_to(authenticated_root_url)
    end
  end

  describe "DELETE #destroy_all" do
    context "when multiple documents are present" do
      let(:documents) { create_list(:blank_document, 3, team: document.team) }

      it "destroys all requested documents" do
        documents
        expect {
          delete destroy_all_documents_url, params: { ids: documents.map(&:id) }
        }.to change(Document, :count).by(-3)
      end

      it "redirects to the documents list" do
        delete destroy_all_documents_url, params: { ids: documents.map(&:id) }
        expect(response).to redirect_to(authenticated_root_url)
      end
    end

    context "when no documents are present" do
      it "does not change the document count" do
        expect {
          delete destroy_all_documents_url, params: { ids: [] }
        }.not_to change(Document, :count)
      end

      it "redirects to the documents list" do
        delete destroy_all_documents_url, params: { ids: [] }
        expect(response).to redirect_to(authenticated_root_url)
      end
    end

    context "when at least one document is present" do
      it "performs a regular destroy" do
        expect {
          delete destroy_all_documents_url, params: { ids: [ document.id ] }
        }.to change(Document, :count).by(-1)
      end

      it "redirects to the documents list" do
        delete destroy_all_documents_url, params: { ids: [ document.id ] }
        expect(response).to redirect_to(authenticated_root_url)
      end
    end
  end
end
