class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         validates :first_name, presence: true
         validates :last_name, presence: true
         validates :user_id, presence: true, uniqueness: true

    def sign_up_params
      params.require(:admin).permit(:first_name, :last_name, :user_id, :email, :password, :confirm_password)
    end

end
