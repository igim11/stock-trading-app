class ApprovedMailer < ApplicationMailer
  default from: 'support@nebulatrade.com'

  def approved_email(user)
    @user = user
    mail(to: @user.email, subject: 'Your account has been approved!')
  end
end
