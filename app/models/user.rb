class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :magic_link_authenticatable,
    :rememberable, :validatable, :trackable, :verifiable
  verify_fields :name

  has_many :teams, dependent: :destroy, inverse_of: :owner
  has_many :memberships, dependent: :destroy, inverse_of: :member
  has_many :teams, through: :memberships
  has_one_attached :avatar
  acts_as_tenant :active_team, class_name: "Team", foreign_key: "active_team_id", optional: true

  validates :name, length: { minimum: 3 }, allow_blank: true

  def self.find_for_authentication(warden_conditions)
    conditions = warden_conditions.dup
    return super(warden_conditions) if conditions.keys.any? { |k| k != :email }

    if conditions[:email].present?
      find_or_create_by(email: conditions[:email])
    end
  end

  def new_personal_team(name)
    return if active_team.present? || name.blank?

    team = teams.build(name: name, owner: self)
    assign_attributes(active_team: team, name: name)
    self.memberships.build(team: team, role: :owner)
    save
  end
end
