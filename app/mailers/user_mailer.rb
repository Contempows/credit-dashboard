class UserMailer < ApplicationMailer
  default from: 'noreply@stc.com'

  def au_created_mail(user)
    @user = user
    mail(to: @user.email, subject: 'Your application has been received')
  end

  def au_accepted_mail(user)
    @user = user
    mail(to: @user.email, subject: 'Congratulations! You are now approved to transact')
  end
end
