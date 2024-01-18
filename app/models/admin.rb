class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         attr_accessor :devise_type

         before_validation :configure_permitted_parameters, if: :devise_type?

         validates :first_name, presence: true
         validates :last_name, presence: true
         validates :user_id, presence: true, uniqueness: true

  private

  def devise_type?
    devise_type.present?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :user_id])
  end

end
