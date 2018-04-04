require 'test_helper'

class PurchasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(email: 'test@gmail.com', role: 0, password: '123456', status: 0, username: 'test', wallet_balance: 500)
    @user1 = User.create(email: 'invited@gmail.com', username: 'invited', password: '123456', invited_by: @user, sign_in_count: 0, role: 0, status: 0)
    @state = State.create(name: 'CA', short_code: 'CA')
    @trade1 = TradeLine.create(bank: 'some', history: 2.years.ago, statement_date: 4s, state: @state, slots: 6, credit_limit: 30000)
    @purchase = Purchase.create(user: @user, purchased_by: @user, trade_line: @trade1, status: 0)
    sign_in @user
  end

  test 'should get new purchase' do
    get new_trade_line_purchase_url(@trade1), xhr: true
    assert_response :success
  end

  test 'Should create new purchase' do
    assert_difference ('Purchase.count') do
      post trade_line_purchases_url(@trade1), params: { purchase: { user_id: @user1.id, trade_line: @trade1, purchased_by: @user, status: 0 } }, xhr: true
    end
    assert_includes Purchase.all, Purchase.last 
  end

  test 'Should update purchase' do
    get edit_trade_line_purchase_url(@trade1, @purchase), xhr: true
    assert_response :success
    patch trade_line_purchase_url(@trade1, @purchase), params: { purchase: { amount: 200, status: 1 } }, xhr: true
    assert_response :success
    @purchase.reload
    assert_equal 200, @purchase.amount
    assert_equal 'submitted', @purchase.status
  end

  test 'Should delete purchase' do
    assert_difference('Purchase.count', -1) do
      delete trade_line_purchase_url(@trade1, @purchase)
    end
    assert_redirected_to purchases_path 
  end
end
