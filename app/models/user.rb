class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :status, inclusion: { in: %w[pending approved], message: "%{value} is not a valid status" }

  before_validation :set_default_status, on: :create
  after_create :notify_admin

  private

  def set_default_status
    self.status = 'pending' if status.blank?
  end

end
