require 'test_helper'

class WithdrawsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, :au, wallet_balance: 100)
    @junior = create(:user, :junior)
    @withdraw = create(:withdraw, withdraw_by: @user)
  end

  test 'should be able to request if there is not active withdrawl' do
    sign_in @user
    get new_withdraw_url, xhr: true
    assert_response :success
  end

  test 'able to request a withdrawal if enough balance' do
    sign_in @user
    assert_difference('Withdraw.count') do
      post withdraws_url, params: { withdraw: { ref: 'ABCDEF', amount: 10, withdraw_by: @user } }, xhr: true
    end

    assert_equal 10.0, Withdraw.last.amount.to_f
    assert_equal @user.reload, Withdraw.last.withdraw_by
  end

  test 'Should update wallet balance of user status if rejected' do
    sign_in @user
    patch withdraw_url(@withdraw), params: { withdraw: { status: 2 } }, headers: { 'HTTP_REFERER' => withdraws_path }, xhr: true
    amount = @withdraw.withdraw_by.wallet_balance
    @withdraw.reload
    assert @withdraw.rejected?
    assert_equal @withdraw.withdraw_by.wallet_balance, @withdraw.amount + amount 
  end

  test 'Should update status as accepted' do
    sign_in @junior
    patch withdraw_url(@withdraw), params: { withdraw: { status: 1 }, approved: 'true' }, headers: { 'HTTP_REFERER'=>withdraws_path }, xhr: true
    @withdraw.reload
    assert @withdraw.approved?
  end
end
