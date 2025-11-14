class DiffsController < ApplicationController
  before_action :set_document
  before_action :set_ref_params
  include ExtractRef


  def index
    if @ref
      walker = Rugged::Walker.new(document.repo)
      walker.push(@ref.target)

      @commits = walker.take(100).map do |commit|
        if current_user.email == commit.author[:email]
          avatar = user_avatar(current_user)
        else
          Rails.logger.info("Finding user by email: #{commit.author[:email]}")
          @user = User.find_by_email(commit.author[:email])
          avatar = user_avatar(@user)
        end

        {
          oid: commit.oid,
          message: commit.message,
          author: commit.author.merge(avatar: avatar || nil, id: @user&.id || current_user.id),
          time: commit.time
        }
      end

      last_commit = @ref.target
      last_editor_blob = document.repo.blob_at(last_commit.oid, Document.file_name)&.content || ""

      Rails.logger.info("[diffs_controller] last_editor_blob: #{last_editor_blob}")

      render inertia: "Document/Diffs", props: {
        document: -> { document.as_json(methods: %i[sqid]).merge(content: Y::Lib0::Encoding.encode_uint8_array_to_base64(JSON.parse(document.content))) },
        current_branch: -> { normalize_branch_name },
        branches: InertiaRails.optional { document.branches },
        commits: InertiaRails.optional { @commits },
        file_content: -> { JSON.parse(last_editor_blob) }
      }
    else
      render inertia: "Document/Diffs", props: {
        document: document.as_json(methods: %i[sqid]).merge(content: Y::Lib0::Encoding.encode_uint8_array_to_base64(JSON.parse(document.content)))
      }
    end
  end

  def snapshots
    render inertia: "Document/SnapshotDiffs", props: {
      document: document.as_json(methods: %i[sqid]).merge(content: Y::Lib0::Encoding.encode_uint8_array_to_base64(JSON.parse(document.content)))
    }
  end

  private

    def set_ref_params
      @ref = assign_ref params[:ref]
    end
    def set_document
      @document = Document.find_by_sqid!(params[:id])
    end
end
