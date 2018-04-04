require 'test_helper'

class RefundTest < ActiveSupport::TestCase
  test 'invalid if password and confirm password or not equal' do
    refund = build(:refund, confirm_password: '123')
    refute refund.save
    assert_equal [I18n.t('refund.pwd_match')], refund.errors[:cm_password] 
  end

  test 'invalid if claim amount if greater than purchase amount' do
    refund = build(:refund, amount: '100') 
    refute refund.save
    assert_equal [I18n.t('refund.claim_amount')], refund.errors[:amount] 
  end

  test 'able to claim total refund' do
    assert build(:refund).save 
  end
end
