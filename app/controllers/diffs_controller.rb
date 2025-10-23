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
          avatar = url_for(current_user.avatar) if current_user.avatar.attached?
        else
          Rails.logger.info("Finding user by email: #{commit.author[:email]}")
          @user = User.find_by_email(commit.author[:email])
          avatar = user_avatar(@user) if @user.avatar.attached?
        end

        {
          oid: commit.oid,
          message: commit.message,
          author: commit.author.merge(avatar: avatar || nil, id: @user&.id || current_user.id),
          time: commit.time
        }
      end

      last_commit = document.repo.last_commit
      last_editor_blob = document.repo.blob_at(last_commit.oid, Document.file_name)&.content || ""

      render inertia: "Document/Diffs", props: {
        document: document.as_json(methods: %i[sqid]),
        current_branch: -> { normalize_branch_name },
        branches: InertiaRails.optional { document.branches },
        commits: InertiaRails.optional { @commits },
        file_content: -> { JSON.parse(last_editor_blob) }
      }
    else
      render inertia: "Document/Diffs", props: {
        document: document.as_json(methods: %i[sqid])
      }
    end
  end

  private

    def set_ref_params
      @ref = assign_ref params[:ref]
    end
    def set_document
      @document = Document.find_by_sqid!(params[:id])
    end
end
