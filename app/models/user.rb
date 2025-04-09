class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :magic_link_authenticatable,
    :rememberable, :validatable, :trackable

  def self.find_for_authentication(warden_conditions)
    conditions = warden_conditions.dup
    return super(warden_conditions) if conditions.keys.any? { |k| k != :email }

    if conditions[:email].present?
      find_or_create_by(email: conditions[:email])
    end
  end
end
