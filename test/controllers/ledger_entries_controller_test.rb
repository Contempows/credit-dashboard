require 'test_helper'

class LedgerEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, :au)
    @junior = create(:user, :junior)
    @state = create(:state)
    @trade_line = create(:trade_line, state: @state)
    @purchase = create(:purchase, trade_line: @trade_line, user: @user, purchased_by: @user)
    @entry = create(:ledger_entry, entry: @purchase, user: @user)
  end

  test "should get root page as AU" do
    sign_in(@user)
    get ledger_entries_url
    assert_redirected_to root_url
  end

  test "should redirect to root page" do
    sign_in(@junior)
    get ledger_entries_url
    assert_redirected_to root_url
  end

  test "should get user's ledger entries when index page is rendered with params as JS" do
    sign_in(@junior)
    get ledger_entries_url(user_check_id: @user)
    assert_includes assigns[:ledger_entries], @entry
    assert_response :success
  end
end
