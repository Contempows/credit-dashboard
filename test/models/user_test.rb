require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should return first three transactions among deposits, purchases and refunds' do
    user = create(:user, :au)

    deposits = create_list(:deposit, 2, user: user)
    purchases = create_list(:purchase, 2, user: user, purchased_by: user)
    refunds = create_list(:refund, 2, purchase: Purchase.last)

    purchase = Purchase.last
    recent_refunds = Refund.order('created_at DESC').pluck(:ref, :amount, :status, :created_at).map do |refund|
      refund = refund.unshift('refund')
      refund[2] = refund[2].to_f.to_s
      refund[4] = refund[4].to_date
      refund
    end      

    recent = user.recent_transactions.map do |trans| 
      trans[4] = trans[4].to_time.to_date 
      trans
    end

    assert_equal recent_refunds + [['purchase', purchase.ref, purchase.amount.to_f.to_s, purchase.status, purchase.created_at.to_date]], recent 
  end
end
