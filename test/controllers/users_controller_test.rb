require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(email: 'test@gmail.com', role: 0, password: '123456', status: 0, username: 'test')
    @user1 = User.create(email: 'invited@gmail.com', username: 'invited', password: '123456', invited_by: @user, sign_in_count: 0, role: 0, status: 0)
    @junior = create(:user, :junior)
  end

  test "should create user" do
    assert_difference ('User.count') do
      post users_url, params: { user: { email: 'test1@gmail.com', username: 'test1', status: 0, password: 'qwerty' } }
    end
    assert_redirected_to edit_user_url(User.last)
  end

  test "should update user after create" do
    get edit_user_url(@user)
    assert_equal status, 200
    patch user_url(@user), params: { user: { first_name: 'First', last_name: 'Last', address: 'Test address', phone: '1234567890', zipcode: '123456' } }
    assert_redirected_to root_url
  end

  test "should create/update user's ssns" do
    sign_in @user
    before = Ssn.all.count
    patch update_ssns_user_url(@user), params: { user: { ssns_attributes: { '0'=>{ssnorcpn: '123456777'}}}, format: :js }
    @user.reload
    assert_equal before+1, Ssn.all.count
  end

  test "should create user when created by broker" do
    sign_in @user
    assert_difference ('User.count') do
      post users_url, params: { user: { email: 'test2@gmail.com', username: 'test2'}, format: :js}
    end
    assert_includes User.all, User.last 
    assert_equal User.last.status, 'submitted'
    assert_equal User.last.role, 'au'
  end

  test "should update user when updated by broker" do
    sign_in @user
    get edit_user_path(@user1), xhr: true
    assert_equal status, 200
    put user_url(@user1), params: { user: { email: 'tester2@gmail.com', username: 'tester2' }, format: :js }
    @user1.reload
    assert_equal 'tester2@gmail.com', @user1.email
    assert_equal 'tester2', @user1.username
  end

  test "should update user's(created by broker) password when logged in for the first time" do
    sign_in @user1
    get edit_password_user_url(@user1)
    assert_equal status, 200
    patch update_password_user_url(@user1), params: { user: { password: '1234567', password_confirmatin: '1234567' } }
    assert_redirected_to new_user_session_url
  end

  test "should update details by user" do
    sign_in @user 
    get edit_details_user_url(@user), xhr: true
    assert_equal status, 200
    patch update_details_user_url(@user), 
      params: { HTTP_REFERER: '/', user: { first_name: 'First', last_name: 'Last', 
			address: 'Test address', phone: '1234567890', zipcode: '123456' } }
    @user.reload
    assert_equal 'First', @user.first_name
    assert_equal 'Last', @user.last_name
    assert_equal 'Test address', @user.address
    assert_equal '1234567890', @user.phone
    assert_equal '123456', @user.zipcode
  end

  test "should destroy user created by broker" do
    sign_in @user
    assert_difference('User.count', -1) do
      delete user_url(@user1)
    end
    assert_redirected_to applications_users_path
  end

  test 'should return submitted & in progress applications' do
    user1 = create(:user, status: 'submitted')
    user2 = create(:user, status: 'in_progress')
    user3 = create(:user) 

    sign_in create(:user, :junior)

    get applications_users_path 

    assert_equal User.applications.order('created_at DESC').to_a, assigns(:applications).to_a
  end

  test 'should change user status when logged in as JS or SS' do
    sign_in @junior
    patch update_details_user_url(@user1), params: { user: { status: 'accepted' } }, xhr: true, headers: { 'HTTP_REFERER'=>'/applications' }
    @user1.reload
    assert_equal @user1.status, 'accepted'
  end

  test 'should add a new JS if SS is logged in' do
    senior = create(:user, :senior)
    sign_in senior
    assert_difference ('User.count') do
      post users_url, params: { user: { email: 'test2@gmail.com', username: 'test2'} }, xhr: true
    end
    assert_equal User.last.status, 'accepted'
    assert_equal User.last.role, 'junior'
  end
end
