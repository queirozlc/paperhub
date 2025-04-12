class Team < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships

  validates :name, presence: true
end
