class Team < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :memberships, dependent: :delete_all
  has_many :members, through: :memberships
  has_many :active_members, class_name: "User", inverse_of: :active_team, foreign_key: "active_team_id", dependent: :nullify
  has_many :documents, dependent: :delete_all
  has_one_attached :cover


  validates :name, presence: true

  def has_owner_role?(user)
    memberships.exists?(member: user, role: :owner)
  end

  def add_member(user, role: :member)
    memberships.create!(member: user, role:) unless already_member? user
  end

  def already_member?(user)
    members.exists?(user.id)
  end

  def remove_member(member)
    return false if member.id == owner.id
    member.set_current_team(member.owned_teams.first) if member.active_team == self
    memberships.find_by(member: member).destroy
  end
end
