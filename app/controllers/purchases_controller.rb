class PurchasesController < ApplicationController
  before_action :authenticate_user!
  def index; end

  def new
    @purchase = Purchase.new
    @trade_line = TradeLine.find(params[:trade_line_id])
    @users = User.where(id: current_user) + User.where(invited_by: current_user)
                                                .where(status: 'accepted')
                                                .profile_details
                                                .order_desc
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def create
    @purchase = Purchase.new(purchase_params.merge(trade_line_id: params[:trade_line_id],
                                                   purchased_by: current_user,
                                                   status: 0))
    @trade_line = TradeLine.find(params[:trade_line_id])
    @users = User.where(id: current_user) + User.where(invited_by: current_user)
                                                .profile_details
                                                .order_desc
    @purchase.save
    respond_to do |format|
      format.js
    end
  end

  def edit
    @purchase = Purchase.find(params[:id])
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def update
    @purchase = Purchase.find(params[:id])
    if current_user.au?
      @purchase.status = 'submitted'
      @purchase.amount = params[:purchase][:amount]
      @result = @purchase.update(purchase_params.except(:amount, :status))

      if @result
        @purchase.reduce_trade_line_slots
        @purchase.deduct_wallet_balance(params[:purchase][:amount].to_f)
        @purchase.add_ledger
        PurchaseMailer.purchase_submitted_mail(current_user, @purchase).deliver_later
        flash[:notice] = I18n.t('purchase.added')
      end
    elsif current_user.staff? && !@purchase.submitted?
      flash[:notice] = "Purchase previously #{@purchase.status}"
      redirect_to root_path
    elsif current_user.staff?
      @purchase.status = if params[:approved] == 'true'
        'approved'
      elsif purchase_params[:status] == 'rejected'
        'rejected'
      end

      @result = if params[:approved] == 'true'
        @purchase.save
      else
        @purchase.update(purchase_params.except(:amount, :status))
      end

      if @result
        if @purchase.rejected?
          @purchase.add_wallet_balance
          @purchase.increase_trade_line_slots
          @purchase.add_ledger
          PurchaseMailer.purchase_rejected_mail(@purchase).deliver_later
        elsif @purchase.approved?
          PurchaseMailer.purchase_accepted_mail(@purchase).deliver_later
        end

        flash[:notice] = I18n.t("purchase.#{@purchase.status}")
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @purchase = Purchase.find(params[:id])
    @trade_line = @purchase.trade_line
    @users = User.where(id: current_user) + User.where(invited_by: current_user)
                                                .where(status: 'accepted')
                                                .profile_details
                                                .order_desc
    if @purchase.destroy
      if params[:delete] == 'true'
        render 'purchases/new.js'
      else
        render json: {}, status: :ok
      end
    end
  end

  private

  def purchase_params
    params.require(:purchase).permit(:user_id, :amount, :status, :reason_for_rejection,
                                     :file_for_ssn, :file_for_dl, :file_for_special_add)
  end
end
