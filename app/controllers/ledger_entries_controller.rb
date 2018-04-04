class LedgerEntriesController < ApplicationController
  before_action :authenticate_user!
  authorize_resource only: [:index]

  def index
    if current_user.au?
      @ledger_entries = current_user.ledger_entries
                                    .includes(:user, :entry)
                                    .paginate_and_order(params[:page], 8)
      @user = current_user
    elsif params[:user_check_id] && current_user.staff?
      user_id = params[:user_check_id]
      @user = User.find(user_id)
      @ledger_entries = LedgerEntry.where(user_id: user_id)
                                   .accessible_by(current_ability)
                                   .includes(:user, :entry)
                                   .paginate_and_order(params[:page], 8)
    else
      respond_to do |format|
        format.html { redirect_to root_url, notice: 'You cannot access this page' }
      end
    end
  end
end
