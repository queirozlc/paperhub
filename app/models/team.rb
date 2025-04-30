class Team < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships
  has_many :projects, dependent: :destroy
  has_one_attached :cover

  validates :name, presence: true
end
