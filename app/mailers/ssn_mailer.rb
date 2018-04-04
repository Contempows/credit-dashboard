class SsnMailer < ApplicationMailer
  def ssn_secured(user)
    @user = user
    mail(to: user.email, subject: 'We have received your SSN/CPN validation request')
  end
end
