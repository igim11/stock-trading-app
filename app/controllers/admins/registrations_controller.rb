class Admins::RegistrationsController < ApplicationController
  before_action :authenticate_admin!
  
  def new
    super
  end

  def create
    super
  end

  def edit
    super
  end

  def update
    super
  end

  def destroy
    super
  end

    def new_user
     super do |user|
       user.admin_approved = false
       user.save
     end
   end

   def create_user
     super do |user|
       user.admin_approved = false
       user.save
       UserMailer.approval_email(user).deliver_later
     end
   end

   def show_user
     super
   end

   def edit_user
     super do |user|
       user.admin_approved = true
       user.save
     end
   end

   def update_user
     super do |user|
       user.admin_approved = true
       user.save
     end
   end

   def destroy
     super
   end
end
