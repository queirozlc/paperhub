class DiffsController < ApplicationController
  before_action :set_document
  attr_reader :document

  include ExtractRef


  def index
    @document.repo.checkout(@ref.name) if @ref.name != @document.repo.head.name

    walker = Rugged::Walker.new(@document.repo)
    walker.push(@ref.target)

    @commits = walker.take(100).map do |commit|
      if current_user.email == commit.author[:email]
        avatar = url_for(current_user.avatar)
      else
        Rails.logger.info("Finding user by email: #{commit.author[:email]}")
        @user = User.find_by_email(commit.author[:email])
        avatar = user_avatar(@user)
      end

      {
        oid: commit.oid,
        message: commit.message,
        author: commit.author.merge(avatar: avatar, id: @user&.id || current_user.id),
        time: commit.time
      }
    end

    render inertia: "Document/Diffs", props: {
      document: @document.as_json(methods: %i[sqid]),
      current_branch: -> { normalize_branch_name },
      branches: InertiaRails.optional { @document.branches },
      commits: InertiaRails.optional { @commits }
    }
  end

  private

    def set_document
      @document = Document.find_by_sqid!(params[:document_id])
    end
end
