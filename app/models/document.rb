class Document < ApplicationRecord
  include Sqids::Rails::Model

  acts_as_tenant :team
  enum :visibility, %i[private public], validate: true, default: :public, prefix: true
  has_sqid min_length: 21

  def repo
    @repo ||= begin
      if Dir.exist?(repo_path)
        Rugged::Repository.new(repo_path)
      else
        Rugged::Repository.init_at(repo_path)
      end
    end
  end

  private
    def repo_path
      Rails.root.join("tmp", "repos", "#{team.id}", "#{sqid}").to_s
    end
end
