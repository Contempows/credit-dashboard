class DashboardController < ApplicationController
  before_action :authenticate_user_logged_in!

  def index
    if current_user.sign_in_count == 1 && current_user.invited_by_id.present?
      redirect_to edit_password_user_path(current_user)
    elsif is_au?
      Purchase.where(status: 'initiated').destroy_all
      @states = State.pluck(:name, :id)
      respond_to do |format|
        format.html
        format.json { render json: TradeLineDatatable.new(view_context) }
      end
    else
      @orders = User.orders
      @users = User.normal_accounts.limit(7)
      @notifications = User.notifications
    end
    @trade_lines = TradeLine.accessible_by(current_ability)
    @can_confirm_deposit = BankingInformation.last.present?
    @latest_ssn_users = Ssn.latest_ssns_group_by_users.keys.first(3)
  end

  def purchases
    @purchases = if current_user.au?
      Purchase.where('purchased_by_id = :user OR user_id = :user', user: current_user.id)
    elsif params[:user_check_id] && current_user.staff?
      Purchase.where('purchased_by_id = :user OR user_id = :user', user: params[:user_check_id])
              .where(status: [1, 2, 3])
    elsif params[:term] && current_user.staff?
      Purchase.search(params[:term])
    else
      Purchase.where(status: [1, 2, 3])
    end.includes(:user, :purchased_by, :refunds).paginate_and_order(params[:page], 8)
    @user = User.find(params[:user_check_id]) if params[:user_check_id]
    @purchases = @purchases.reorder(:status, updated_at: :desc)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def about_us; end

  def contact_us; end

  private

  def authenticate_user_logged_in!
    redirect_to new_user_session_path unless user_signed_in?
  end
end
