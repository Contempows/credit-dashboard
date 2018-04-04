require 'test_helper'

class TradeLinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in create(:user, :senior)
    @trade_line = create(:trade_line) 
  end

  test "should get index" do
    get trade_lines_url
    assert_response :success
  end

  test "should get new" do
    get new_trade_line_url
    assert_response :success
  end

  test "should create trade_line" do
    assert_difference('TradeLine.count') do
      post trade_lines_url, params: { trade_line: { bank: 'BOA', 
						    credit_limit: '2000',
						    dl_req: true, 
						    history: @trade_line.history.strftime('%m/%d/%y'),
						    price: 20, 
						    slots: 10,  
						    special_add: true,
						    ssn_req: false, 
						    state_id: create(:state, name: 'sdfd', short_code: 'fs').id, 
						    statement_date: @trade_line.statement_date } }, xhr: true
    end

    tl = TradeLine.last

    assert_equal 'BOA', tl.bank
    assert_equal 2000, tl.credit_limit
    assert_equal Time.now.yesterday.to_date.to_s, tl.history.to_s
    assert_equal 20, tl.price.to_f
    assert_equal 10, tl.slots
    assert tl.special_add
    refute tl.ssn_req
    assert_equal 'sdfd', tl.state.name
    assert_equal 4, tl.statement_date
  end

  test "should update trade line" do
    put trade_line_url(@trade_line), params: { trade_line: { bank: 'BOA', 
						  credit_limit: '2000',
						  dl_req: true, 
						  history: @trade_line.history.strftime('%m/%d/%y'),
						  price: 20, 
						  slots: 10,  
						  special_add: true,
						  ssn_req: false, 
						  state_id: create(:state, name: 'sdfd', short_code: 'fs').id, 
						  statement_date: @trade_line.statement_date } }, xhr: true

    tl = @trade_line.reload 

    assert_equal 'BOA', tl.bank
    assert_equal 2000, tl.credit_limit.to_f
    assert_equal Time.now.yesterday.to_date.to_s, tl.history.to_s
    assert_equal 20, tl.price.to_f
    assert_equal 10, tl.slots
    assert tl.special_add
    refute tl.ssn_req
    assert_equal 'sdfd', tl.state.name
  end

  test "should destroy trade_line" do
    assert_difference('TradeLine.count', -1) do
      delete trade_line_url(@trade_line)
    end

    assert_redirected_to trade_lines_url
  end
end
