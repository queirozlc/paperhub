class BranchesController < ApplicationController
  before_action :set_document

  def create
    # if branch name has spaces then replace them with hyphens
    branch_name = branch_params[:name].gsub(" ", "-")
    target = branch_params[:target]

    commit = @document.repo.rev_parse(target)

    @branch = @document.repo.branches.create(branch_name, commit.oid)
    redirect_to diffs_document_path(@document, @branch.name), notice: "Branch '#{@branch.name}' created successfully."
  end

  private

    def set_document
      @document = Document.find_by_sqid!(params[:document_id])
    end

    def branch_params
      params.expect(branch: [ :name, :target ])
    end
end
