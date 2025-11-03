class Document < ApplicationRecord
  include Sqids::Rails::Model

  after_create_commit :init_repository
  after_destroy_commit :close_repository

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

    # The path must be on the storage mount because is a path that exists both in development and production
    # the storage is a mounted volume which is persistent between deployments
    def path
      Rails.root.join("storage", "repos", "#{team.id}", "#{sqid}").to_s
    end

    def init_repository
      Rugged::Repository.init_at path, :bare
    end

    def close_repository
      if Dir.exist?(path)
        FileUtils.rm_rf(path)
      end
    end
end
