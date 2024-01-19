class PendingMailer < ApplicationMailer
  default from: 'support@nebulatrade.com'

  def pending_email(user)
    @user = user
    mail(to: @user.email, subject: 'Your account is pending approval')
  end
end
