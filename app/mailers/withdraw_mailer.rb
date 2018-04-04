class WithdrawMailer < ApplicationMailer
  def requested_withdraw(withdraw)
    @withdraw_by = withdraw.withdraw_by
    @withdraw = withdraw
    amount = number_to_currency(@withdraw.amount, precision: 2)
    mail(to: @withdraw_by.email,
         subject: "We have received your withdrawal request of #{amount}")
  end

  def request_approved(withdraw)
    @withdraw_by = withdraw.withdraw_by
    @withdraw = withdraw
    amount = number_to_currency(@withdraw.amount, precision: 2)
    mail(to: @withdraw_by.email,
         subject: "Your withdrawal request of #{amount} has been approved")
  end
end
