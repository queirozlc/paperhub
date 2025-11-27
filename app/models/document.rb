class Document < ApplicationRecord
  include GitTrackable
  include Sqids::Rails::Model

  GIT_FILEMODE_UNREADABLE = 0
  GIT_FILEMODE_TREE = 040000
  GIT_FILEMODE_BLOB = 0100644
  GIT_FILEMODE_LINK = 0120000
  GIT_FILEMODE_COMMIT = 0160000

  BRANCH_REF_PREFIX = "refs/heads/"

  acts_as_tenant :team
  enum :visibility, %i[private public], validate: true, default: :public, prefix: true
  has_sqid min_length: 21

  class << self
    def file_name
      "editor.json"
    end
  end

  def branches
    repo.branches.map(&:name)
  end

  def repo
    Rugged::Repository.new(path)
  rescue Rugged::RepositoryError, Rugged::OSError
    Rugged::Repository.init_at(path, :bare)
  end

  def root_ref
    @root_ref ||= discover_default_branch
  end

  def repo_head?
    repo.head
  end

  def extract_ref_name(ref_name)
    ref_name.sub(BRANCH_REF_PREFIX, "")
  end

  private
    def discover_default_branch
      names = branches

      return if names.empty?

      return names[0] if names.length == 1

      if repo_head?
        extract_ref_name(repo.head.name)
      else
        return "master" if names.include?("master")
        names[0]
      end
    end
end
