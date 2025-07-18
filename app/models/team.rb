class Team < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships
  has_many :documents, dependent: :destroy
  has_one_attached :cover

  validates :name, presence: true

  def has_owner_role?(user)
    memberships.exists?(member: user, role: :owner)
  end

  def add_member(user, role:)
    memberships.create!(member: user, role:) unless already_member? user
  end

  def already_member?(user)
    members.exists?(user.id)
  end
end
