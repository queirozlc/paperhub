module ExtractRef
  extend ActiveSupport::Concern

  included do
    attr_reader :document
  end

  private

    def assign_ref(ref)
      ref_name = if ref.present?
        "refs/heads/#{ref}"
      else
        document.repo.head.name unless document.repo.empty?
      end

      document.repo.references[ref_name] if ref_name.present?
    end

    def normalize_branch_name
      return document.root_ref if @ref.nil? || @ref.name == "HEAD"
      document.extract_ref_name(@ref.name)
    end
end
