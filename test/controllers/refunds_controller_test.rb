require 'test_helper'

class RefundsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @purchase = create(:purchase)
    sign_in @purchase.purchased_by
  end

  test "should get new" do
    get new_refund_url, params: { purchase_id: @purchase.id }, xhr: true 
    assert_equal @purchase, assigns(:refund).purchase
  end

  test 'should not ask one more refund if there is a active refund' do
    refund = create(:refund, purchase: @purchase)
    get new_refund_url, params: { purchase_id: @purchase.id }, xhr: true 
    assert_equal I18n.t('refund.has_active_refund'), flash[:error] 
  end

  test 'should not able to ask refund once after one month of purchase' do
    @purchase.update_columns(created_at: Time.zone.now - 31.day)
    get new_refund_url, params: { purchase_id: @purchase.id }, xhr: true 
    assert_equal I18n.t('refund.grace_period'), flash[:error] 
  end

  test 'able to request refund for a purchase' do
    attributes = attributes_for(:refund, purchase: @purchase)
                 .except(:status).merge(purchase_id: @purchase.id)
    post refunds_url, 
      params: { refund: attributes }, 
      xhr: true

    refund = Refund.last
    assert_equal 'MyString', refund.reason
    assert_equal 'MyString', refund.cm_service
    assert_equal Base64.encode64('MyString'), refund.cm_login
    assert_equal Base64.encode64('123456'), refund.cm_password
    assert_equal 9.99, refund.amount.to_f 
    assert_equal 'submitted', refund.status
    assert_equal @purchase, refund.purchase
    assert refund.ref
  end

  test 'should set amt refunded to zero if refund got rejected' do
    refund = create(:refund, purchase: @purchase)

    put refund_url(refund), params: { refund: { id: refund.id, status: 'rejected' } }, xhr: true
    refute refund.reload.amount_refunded
  end

  test 'should set amt refunded to amount if refund got accepted' do
    refund = create(:refund, purchase: @purchase)

    put refund_url(refund), params: { refund: { id: refund.id, status: 'accepted' } }, xhr: true
    assert_equal refund.reload.amount, refund.reload.amount_refunded
  end

  test 'should set amt refunded to passed value if refund got partially accpeted' do
    refund = create(:refund, purchase: @purchase)

    put refund_url(refund), params: { refund: { amount_refunded: '5', id: refund.id, 
						status: 'partially_accepted' } }, 
      xhr: true
    assert_equal 5, refund.reload.amount_refunded

    put refund_url(refund), params: { refund: { id: refund.id, 
						status: 'in_progress' } }, 
      xhr: true
    refute refund.reload.amount_refunded
  end
end
