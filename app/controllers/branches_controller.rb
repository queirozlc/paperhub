class BranchesController < ApplicationController
  before_action :set_document

  def create
    # if branch name has spaces then replace them with hyphens
    branch_name = branch_params[:name].gsub(" ", "-")
    @branch = @document.repo.branches.create(branch_name, branch_params[:target])
    @document.repo.checkout(@branch.name)
    redirect_to document_diffs_path(@document), notice: "Branch was successfully created."
  end

  private

    def set_document
      @document = Document.find_by_sqid!(params[:document_id])
    end

    def branch_params
      params.expect(branch: [ :name, :target ])
    end
end
