class DepositMailer < ApplicationMailer
  helper :application
  default from: 'noreply@stc.com'

  def au_deposit_added_mail(deposit)
    @deposit = deposit
    @user = deposit.user
    amount = @deposit.amount
    mail(
      to: @user.email,
      subject: "We've received your deposit confirmation for #{number_to_currency(amount, precision: 2)}"
    )
  end

  def au_deposit_accepted_mail(deposit)
    @deposit = deposit
    @user = deposit.user
    mail(to: @user.email,
         subject: "Your deposit of #{number_to_currency(@deposit.amount, precision: 2)} has been confirmed")
  end
end
