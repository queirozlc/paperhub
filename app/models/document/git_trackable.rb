module Document::GitTrackable
  extend ActiveSupport::Concern

  included do
    after_create_commit :init_repository
    after_destroy_commit :close_repository
  end

  def init_repository
    Rugged::Repository.init_at path, :bare
  end

  private
    def close_repository
      if Dir.exist?(path)
        FileUtils.rm_rf(path)
      end
    end

    # The path must be on the storage mount because is a path that exists both in development and production
    # the storage is a mounted volume which is persistent between deployments
    def path
      Rails.root.join("storage", "repos", "#{team.id}", "#{sqid}").to_s
    end
end
