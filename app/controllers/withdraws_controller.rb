class WithdrawsController < ApplicationController
  before_action :authenticate_user!

  def index
    @withdraws = if current_user.au?
      Withdraw.where(withdraw_by: current_user)
    elsif params[:user_check_id] && current_user.staff?
      Withdraw.where(withdraw_by_id: params[:user_check_id])
    else
      Withdraw.all
    end.includes(:withdraw_by).paginate_and_order(params[:page], 8)
    @withdraws = @withdraws.reorder(:status, updated_at: :desc)
    @user = User.find(params[:user_check_id]) if params[:user_check_id]
  end

  def new
    @withdraw = Withdraw.new(amount: '')
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def create
    @withdraw = Withdraw.new(withdraw_params.merge(withdraw_by: current_user))
    if @withdraw.save
      WithdrawMailer.requested_withdraw(@withdraw).deliver_later
      @withdraw.add_ledger
      flash[:notice] = I18n.t('withdraw.added')
    end
  end

  def edit
    @withdraw = Withdraw.find(params[:id])
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def update
    @withdraw = Withdraw.find(params[:id])
    if @withdraw.requested?
      @withdraw.status = (params[:approved] == 'true' ? 1 : 2)
      @withdraw.save

      if @withdraw.rejected?
        user = @withdraw.withdraw_by
        user.update_attributes(wallet_balance: user.wallet_balance + @withdraw.amount)
        @withdraw.add_ledger
      else
        WithdrawMailer.request_approved(@withdraw).deliver_later
      end

      flash[:notice] = I18n.t("withdraw.#{@withdraw.status}")
    else
      flash[:notice] = "Withdraw already #{@withdraw.status}"
    end
  end

  private

  def withdraw_params
    params.require(:withdraw).permit(:amount, :payee, :address)
  end
end
