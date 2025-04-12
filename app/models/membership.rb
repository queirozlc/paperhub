class Membership < ApplicationRecord
  belongs_to :member, class_name: "User", foreign_key: "member_id"
  belongs_to :team

  enum :role, [ :owner, :member ], validate: true
  validates :role, presence: true

  def self.owner?(user, team)
    find_by(member: user, team: team)&.owner?
  end
end
