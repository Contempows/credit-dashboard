class RefundsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_refund, only: %i[show edit update destroy download]

  def index
    @refunds = if current_user.au?
      Refund.where(purchase: Purchase.where(purchased_by: current_user))
    elsif params[:user_check_id] && current_user.staff?
      Refund.where(purchase: Purchase.where(purchased_by_id: params[:user_check_id]))
    elsif params[:term] && current_user.staff?
      Refund.where(purchase: Purchase.search(params[:term]))
    else
      Refund.all
    end.includes(:purchase).paginate_and_order(params[:page], 8)

    @refunds = @refunds.reorder(:status, updated_at: :desc)

    @user = User.find(params[:user_check_id]) if params[:user_check_id]
  end

  def new
    @purchase = Purchase.find(params[:purchase_id])

    if @purchase.has_active_refund?
      flash.now[:error] = I18n.t('refund.has_active_refund')
      render && return
    end

    if Time.zone.now > (@purchase.created_at + 6.weeks)
      flash.now[:error] = I18n.t('refund.grace_period')
      render && return
    end
    @refund = @purchase.refunds.build
    respond_to do |format|
      format.html { redirect_to purchases_path }
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def create
    @refund = Refund.new(refund_params)
    if @refund.save
      RefundMailer.refund_requested(@refund).deliver_later
      (flash[:notice] = I18n.t('refund.create'))
    end
  end

  def update
    if @refund.submitted?
      @refund.amount_refunded = if refund_params[:status] == 'accepted'
        @refund.purchase.amount
      else
        refund_params[:amount_refunded]
      end

      if @refund.update(refund_params.except(:amount_refunded))

        if @refund.accepted? || @refund.partially_accepted?
          @refund.add_money
          @refund.add_ledger
          RefundMailer.refund_approved(@refund).deliver_later
        end

        RefundMailer.refund_rejected(@refund).deliver_later if @refund.rejected?

        flash[:notice] = I18n.t("refund.#{@refund.status}")
      else
        flash.now[:error] = I18n.t('refund.error', error: @refund.errors.full_messages.join(', '))
      end
    else
      flash[:notice] = "Refund previously #{@refund.status}"
    end
  end

  private

  def set_refund
    @refund = Refund.find(params[:id])
  end

  def refund_params
    params.require(:refund).permit(:reason, :cm_service, :cm_login, :cm_password, :confirm_password,
                                   :reason_for_rejection, :reason_for_inprogress, :attachment,
                                   :amount, :status, :purchase_id, :amount_refunded, :info)
  end
end
