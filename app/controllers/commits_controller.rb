class CommitsController < ApplicationController
  before_action :set_document
  before_action :set_ref_params
  include ExtractRef


  # POST /documents/:document_id/commits
  def create
    message = if commit_params[:description].present?
      "#{commit_params[:message]}\n\n#{commit_params[:description]}"
    else
      commit_params[:message]
    end

    options = {
      file: {
        path: Document.file_name,
        content: JSON.parse(commit_params[:content]),
        mode: Document::GIT_FILEMODE_BLOB
      },
      author: {
        name: current_user.name,
        email: current_user.email,
        time: Time.now
      },
      committer: {
        name: current_user.name,
        email: current_user.email,
        time: Time.now
      },
      commit: {
        message: message,
        update_ref: "HEAD",
        parents: []
      }
    }

    file = options[:file]
    author = options[:author]
    committer = options[:committer]
    commit = options[:commit]

    repo = document.repo
    index = repo.index

    unless repo.empty?
      ref = repo.references[@ref.name]
      last_commit = ref.target
      commit[:parents] = [ last_commit ]
      commit[:update_ref] = ref.name
      index.read_tree(last_commit.tree)
    end

    file_entry = index.get(file[:path])

    if file_entry
      file[:mode] = file_entry[:mode]
    end

    oid = repo.write(JSON.generate(file[:content]), :blob)
    index.add(path: file[:path], oid:, mode: file[:mode])

    commit_opts = {
      tree: index.write_tree(repo),
      author:,
      committer:,
      message: commit[:message],
      parents: commit[:parents],
      update_ref: commit[:update_ref]
    }

    Rugged::Commit.create(repo, commit_opts)
    Rails.logger.info("Commit created: #{commit[:update_ref]}")

    redirect_to diffs_document_path(document, ref: normalize_branch_name), notice: "Commit was successfully created."
  end

  private
    def set_ref_params
      @ref = assign_ref commit_params[:ref]
    end

    def commit_params
      params.expect(commit: %i[message description ref content])
    end

    def set_document
      @document = Document.find_by_sqid! params.expect(:document_id)
    end
end
