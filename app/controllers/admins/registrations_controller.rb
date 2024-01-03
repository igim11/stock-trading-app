class Admins::RegistrationsController < ApplicationController
  def create
    super do |user|
      user.admin_approved = false
      user.save
      UserMailer.approval_email(user).deliver_later
    end
  end
end
