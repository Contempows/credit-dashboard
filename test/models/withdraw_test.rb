require 'test_helper'

class WithdrawTest < ActiveSupport::TestCase
  test 'should not be able to request more than wallet balance' do
    user = create(:user, :au, wallet_balance: 10)
    withdraw = build(:withdraw, withdraw_by: user, amount: 11)
    refute withdraw.valid?
    assert_equal ["must be less than or equal to 10.0"], withdraw.errors[:amount]
  end
end
