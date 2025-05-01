class Project < ApplicationRecord
  include Sqids::Rails::Model

  acts_as_tenant :team
  enum :visibility, %i[private public], validate: true, default: :public, prefix: true
  validates :visibility, presence: true
  has_sqid :long_sqid, min_length: 24
  has_sqid min_length: 21
end
