require 'test_helper'

class DepositsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user, :au)
    @user1 = create(:user, :au)
    @junior = create(:user, :junior)
    @deposit = create(:deposit, user_id: @user.id)
    @deposit1 = create(:deposit, user_id: @user1.id)
  end

  test "should get index page as AU" do
    sign_in @user
    get deposits_url
    assert_response :success
    assert_equal assigns[:deposits], [@deposit]
    assert_not_includes assigns[:deposits], @deposit1
  end

  test 'should get index as JS' do 
    sign_in @junior
    get deposits_url
    assert_response :success
    assert_equal assigns[:deposits], [@deposit1, @deposit]
  end

  test 'should get index for a specific AU when logged in as JS or SS' do
    sign_in @junior
    get deposits_url, params: { user_check_id: @user.id }
    assert_response :success
    assert_equal assigns[:deposits], [@deposit]
    assert_not_includes assigns[:deposits], @deposit1
  end

  test "should get new" do
    sign_in @user
    get new_deposit_url, xhr: true
    assert_response :success
  end

  test "should create deposit" do
    banking_info = create(:banking_information)
    sign_in @user

    assert_difference('Deposit.count') do
      post deposits_url, params: { deposit: { amount: @deposit.amount, date_of_deposit: Time.zone.today.strftime("%m/%d/%y"), authorization_code: Deposit.new.generate_ref_code(Deposit), status: @deposit.status, user_id: @deposit.user_id, attachment:  fixture_file_upload("#{Rails.root}/public/apple-touch-icon.png"), banking_information_id: banking_info.id} }, xhr: true 
    end

    assert_response :success
  end

end
