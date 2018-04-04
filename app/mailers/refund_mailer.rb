class RefundMailer < ApplicationMailer
  helper :application

  def refund_requested(refund)
    @user = refund.purchase.purchased_by
    client = refund.purchase.user
    @refund = refund
    @trade_line = refund.purchase.trade_line
    @purchase = refund.purchase
    mail(to: @user.email,
         subject: "We have received your refund request for #{client.first_name} #{client.last_name}")
  end

  def refund_approved(refund)
    @user = refund.purchase.purchased_by
    client = refund.purchase.user
    @refund = refund
    @purchase = refund.purchase
    @trade_line = refund.purchase.trade_line
    mail(to: @user.email,
         subject: "Your refund for #{client.first_name} #{client.last_name} is approved")
  end

  def refund_rejected(refund)
    @user = refund.purchase.purchased_by
    client = refund.purchase.user
    @refund = refund
    @purchase = refund.purchase
    @trade_line = refund.purchase.trade_line
    mail(to: @user.email,
         subject: "We are unable to process your refund for #{client.first_name} #{client.last_name}")
  end
end
