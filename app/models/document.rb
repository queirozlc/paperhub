class Document < ApplicationRecord
  include Sqids::Rails::Model

  acts_as_tenant :team
  enum :visibility, %i[private public], validate: true, default: :public, prefix: true
  has_sqid min_length: 21
end
