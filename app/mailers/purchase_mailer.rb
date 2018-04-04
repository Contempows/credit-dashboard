class PurchaseMailer < ApplicationMailer
  helper :application

  def purchase_submitted_mail(user, purchase)
    @user = user
    @purchase = purchase
    client = purchase.user
    @trade_line = purchase.trade_line
    mail(to: @user.email,
         subject: "We have received your order for #{client.first_name} #{client.last_name}")
  end

  def purchase_accepted_mail(purchase)
    @user = purchase.purchased_by
    @purchase = purchase
    client = purchase.user
    @trade_line = purchase.trade_line
    mail(to: @user.email,
         subject: "Your order for #{client.first_name} #{client.last_name} has been confirmed")
  end

  def purchase_rejected_mail(purchase)
    @user = purchase.purchased_by
    @purchase = purchase
    client = purchase.user
    @trade_line = purchase.trade_line
    mail(to: @user.email,
         subject: "Your order for #{client.first_name} #{client.last_name} has been rejected")
  end
end
