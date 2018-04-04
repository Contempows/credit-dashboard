require 'test_helper'

class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @junior = create(:user, :junior)
    sign_in(@junior)
  end

  test "should get new page" do
    assert_equal Setting.count, 0
    get new_setting_url, xhr: true
    assert_response :success
  end

  test "should create a new setting" do
    assert_equal Setting.count, 0
    assert_difference('Setting.count') do
      post settings_url, params: { setting: { ssn_charge: 1 } }, xhr: true 
    end
    assert_equal Setting.last.ssn_charge, 1
  end

  test "should get edit page" do
    @setting = create(:setting)
    assert_equal Setting.count, 1
    get edit_setting_url(@setting), xhr: true
    assert_response :success
  end

  test "Should Update last setting record" do
    @setting = create(:setting)
    assert_equal Setting.count, 1
    patch setting_url(@setting), params: { setting: { ssn_charge: 10 } }, xhr: true
    Setting.last.reload
    assert_equal Setting.last.ssn_charge, 10
  end
end
