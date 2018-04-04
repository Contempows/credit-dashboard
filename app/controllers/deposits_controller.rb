class DepositsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_deposit, only: %i[edit update destroy]

  def index
    @deposits = if current_user.au?
      Deposit.where(user_id: current_user.id)
    elsif params[:user_check_id] && current_user.staff?
      Deposit.where(user_id: params[:user_check_id])
    else
      Deposit.all
    end.includes(:user).paginate_and_order(params[:page], 8)
    @deposits = @deposits.reorder(:status, updated_at: :desc)
    @user = User.find(params[:user_check_id]) if params[:user_check_id]
  end

  def new
    @banking_infos = BankingInformation.all.pluck(:bank_name, :id)
    @deposit = if params[:broker_id]
      User.find(params[:broker_id]).deposits.build
    else
      current_user.deposits.build
    end
    @deposit.generate_auth_code
    @deposit.amount = ''
    respond_to do |format|
      format.html { redirect_to root_path }
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
    deposit_user = if params[:broker_id]
      User.find(params[:broker_id])
    else
      current_user
    end
    @result = Deposit::Create.call(deposit_params, user: deposit_user, current_user: current_user)
    @deposit = @result['model']
    if @result.success?
      if current_user.junior?
        @result['model'].add_to_wallet
        @result['model'].add_ledger
        flash[:notice] = if params.dig(:deposit, :amount).to_i.negative?
          I18n.t('deposit.debited')
        else
          I18n.t('deposit.accepted')
        end
        respond_to do |format|
          format.html { redirect_to root_path }
          format.js
        end
      else
        flash[:notice] = I18n.t('deposit.added')
        DepositMailer.au_deposit_added_mail(@result['model']).deliver_later
        render json: {}, status: :ok
      end
    elsif current_user.au?
      render json: { errors: @result['model'].errors }, status: :unprocessable_entity
    else
      render 'deposits/create.js'
    end
  end

  def update
    if @deposit.deposited?
      if @deposit.update(deposit_params)
        @deposit.add_to_wallet
        @deposit.add_ledger if deposit_params[:status] == 'accepted'
        flash[:notice] = I18n.t("deposit.#{deposit_params[:status]}")
      else
        flash.now[:error] = @deposit.errors.full_messages.join(', ')
      end
      DepositMailer.au_deposit_accepted_mail(@deposit).deliver_later if @deposit.accepted?
    else
      flash[:notice] = "Deposit previously #{@deposit.status}"
    end
  end

  private

  def set_deposit
    @deposit = Deposit.find(params[:id])
  end

  def deposit_params
    params.require(:deposit).permit(:amount, :date_of_deposit, :authorization_code,
                                    :attachment, :status, :banking_information_id)
  end
end
