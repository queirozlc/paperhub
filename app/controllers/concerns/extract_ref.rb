module ExtractRef
  extend ActiveSupport::Concern

  included do
    attr_reader :document
    before_action :assign_ref
  end

  private

    def assign_ref
      ref_name = if params[:ref].present?
        "refs/heads/#{params[:ref]}"
      else
        document.repo.head.name
      end

      @ref = document.repo.references[ref_name]
    end

    def normalize_branch_name
      @ref.name.gsub("refs/heads/", "")
    end
end
