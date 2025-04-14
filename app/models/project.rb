class Project < ApplicationRecord
  acts_as_tenant :team
  enum :visibility, %i[private public], validate: true, default: :public, prefix: true
  validates :visibility, presence: true
end
