class User < ApplicationRecord
  include OwnershipTransferable

  INVITATIONS_FIELDS = %i[ invited_by invited_team invitation_role invitation_token invitation_sent_at invitation_created_at invitation_accepted_at ].freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :magic_link_authenticatable, :rememberable, :validatable,
         :trackable, :verifiable

  verify_fields :name

  enum :invitation_role, [ :owner, :member ], validate: { allow_nil: true }

  belongs_to :invited_team, class_name: "Team", optional: true
  has_many :owned_teams, class_name: "Team", foreign_key: :owner_id, inverse_of: :owner, dependent: :destroy
  has_many :memberships, dependent: :destroy, inverse_of: :member
  has_many :teams, through: :memberships
  has_many :invitations, class_name: self.to_s, inverse_of: :invited_by, dependent: :nullify
  has_one_attached :avatar
  acts_as_tenant :active_team, class_name: "Team", optional: true

  validates :name, length: { minimum: 3 }, allow_blank: true

  after_invitation_accepted :join_invited_team

  scope :unaccepted_invitations, ->(user) { with_attached_avatar.invitation_not_accepted.where(invited_by: user, invited_team_id: user.active_team_id) }

  scope :with_role, -> { select("memberships.role, users.*").joins(:memberships) } do
    def with_team(team)
      where(memberships: { team_id: team.id })
    end

    def without_me(user)
      where.not(id: user.id)
    end
  end

  def self.find_for_authentication(warden_conditions)
    conditions = warden_conditions.dup
    return super(warden_conditions) if conditions.keys.any? { |k| k != :email }

    if conditions[:email].present?
      find_or_create_by(email: conditions[:email])
    end
  end

  def new_personal_team(attrs = {})
    name = attrs[:name]
    return if active_team.present? || name.blank?

    team = teams.build(name: name, owner: self)
    assign_attributes(active_team: team, name: name)
    memberships.build(team: team, role: :owner)
    save
  end

  def set_current_team(team)
    ActsAsTenant.with_mutable_tenant do
      update!(active_team: team)
    end
  end

  def can_invite?(invited_user)
    return false unless active_team.present?
    return false if active_team.already_member?(invited_user)
    active_team.has_owner_role?(self)
  end

  def invite_for_team(invited_user, invitation_role: :member)
    if active_team.present?
      invited_user.invited_team = active_team
      invited_user.invitation_role = invitation_role
    end
  end

  def role_in(team)
    memberships.find_by(team:)&.role
  end

  def revoke_invitation!(user_invitation)
    INVITATIONS_FIELDS.each do |field|
      user_invitation.send("#{field}=", nil)
    end
    user_invitation.save!
  end

  private

    def join_invited_team
      return unless invited_team.present?

      invited_team.add_member(self, role: invitation_role)
      set_current_team invited_team
      self.invited_team = nil
      self.invitation_role = nil
      save!
    end
end
