require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(email: 'test@gmail.com', role: 0, password: '123456', 
			status: 0, username: 'test', wallet_balance: 1000)
    @user1 = User.create(email: 'test123@gmail.com', role: 0, password: '123456', 
			 status: 0, username: 'test123', invited_by: @user, wallet_balance: 100, 
			 updated_at: Time.current)
    @user2 = User.create(email: 'test1234@gmail.com', role: 0, password: '123456', 
			 status: 0, username: 'test1234', invited_by: @user, 
			 updated_at: Time.current-2.hours, wallet_balance: 10000)
    @junior = User.create(email: 'junior@gmail.com', role: 1, password: '123456', 
			  status: 2, username: 'junior')
    @state = State.create(name: 'CA', short_code: 'CA')
    @trade1 = TradeLine.create(bank: 'some', history: 2.years.ago, is_active: true, 
			       statement_date: 4, 
			       state: @state, slots: 6, credit_limit: 30000)
    @trade2 = TradeLine.create(bank: 'some', history: 2.years.ago, is_active: true, 
			       statement_date: 4, 
			       state: @state, slots: 6, credit_limit: 30000)
    @trade3 = TradeLine.create(bank: 'some', history: 2.years.ago, is_active: true, 
			       statement_date: 4, 
			       state: @state, slots: 6, credit_limit: 30000)
    @trade4 = TradeLine.create(bank: 'some', history: 2.years.ago, is_active: true, 
			       statement_date: 4s, 
			       state: @state, slots: 6, credit_limit: 30000)
    @purchase = Purchase.create(ref: 'AERTYU', user: @user1, purchased_by: @user, 
				trade_line: @trade1, amount: 200, status: 0)
    @purchase1 = Purchase.create(ref: 'AERTYU', user: @user1, purchased_by: @user1, 
				 trade_line: @trade1, amount: 200, status: 0)
  end

  test "should get index after signin" do
    allow(@user).to receive(:recent_transactions).and_return([])
    sign_in @user
    get root_path
    assert_equal '/', path
    assert_equal assigns[:trade_lines], [@trade4, @trade3, @trade2]
    assert_equal assigns[:users], [@user1, @user2]
    assert_equal assigns[:users], [@user1, @user2]
    expect(@user).to have_received(:recent_transactions)
    assert_response :success
  end

  test "should get sign in path if not signin" do
    get root_path
    assert_redirected_to new_user_session_url
  end

  test "should get submitted applications page" do
    sign_in @user
    get applications_users_path
    assert_equal '/users/applications', path
    assert_equal assigns[:applications], [@user1, @user2]
    assert_response :success
  end

  test "should get transactions page" do
    sign_in @user
    get purchases_path 
    assert_equal assigns[:purchases], [@purchase]
  end

  test "should get purchases page as AU" do
    sign_in @user
    get purchases_url
    assert_response :success
    assert_equal assigns[:purchases], [@purchase]
    assert_not_includes assigns[:purchases], @purchase1
  end

  test 'should get purchases as JS' do 
    sign_in @junior
    @purchase.update_attributes(status: 'submitted')
    get purchases_url
    assert_response :success
    assert_equal [@purchase.reload], assigns(:purchases)
  end

  test 'should get purchases for a specific AU when logged in as JS or SS' do
    sign_in @junior
    @purchase.update_attributes(status: 'submitted')
    get purchases_url, params: { user_check_id: @user.id }
    assert_response :success
    assert_equal [@purchase], assigns[:purchases] 
  end
end
