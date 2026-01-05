class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Role-based access control
  enum :role, { user: 0, admin: 1 }, default: :user

  # Scopes
  scope :admins, -> { where(role: :admin) }
  scope :regular_users, -> { where(role: :user) }

  # Default role for new users
  after_initialize :set_default_role, if: :new_record?

  private

  def set_default_role
    self.role ||= :user
  end
end
