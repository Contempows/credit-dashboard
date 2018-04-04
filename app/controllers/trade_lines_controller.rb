class TradeLinesController < ApplicationController
  before_action :authenticate_user!
  authorize_resource only: [:index]

  before_action :set_trade_line, only: %i[show edit update destroy]

  def index
    @all_trade_lines = TradeLine.accessible_by(current_ability)
    @states = State.pluck(:name, :id)
    respond_to do |format|
      format.html { redirect_to root_path if current_user.au? }
      format.json { render json: TradeLineDatatable.new(view_context) }
    end
  end

  def new
    @states = State.pluck(:name, :id)
    @trade_line = TradeLine.new(slots: '', credit_limit: '', price: '',
                                special_add: '', ssn_req: '', dl_req: '')
    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
    end
  end

  def show
    respond_to do |format|
      format.js
    end
    authorize! :read, @trade_line
  end

  def edit
    @states = State.pluck(:name, :id)
    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
    end
  end

  def create
    @result = TradeLine::Create.call(trade_line_params.merge(trade_line: TradeLine.new))
    @trade_line = @result['model']
    @states = @result['states']
    @trade_lines = @result['trade_lines']
    flash[:notice] = I18n.t('tradeline.added')
  end

  def update
    if params[:commit] == 'Delete Tradeline'
      @destroyed = @trade_line.destroy
      @success = @trade_line.errors.empty?
      flash[:notice] = I18n.t('tradeline.deleted')
    else
      @result = TradeLine::Create.call(trade_line_params.merge(trade_line: @trade_line))
      @trade_line = @result['model']
      @states = @result['states']
      @trade_lines = @result['trade_lines']
      @success = @result.success?
      flash[:notice] = I18n.t('tradeline.updated')
    end
  end

  def destroy
    @trade_line.destroy
    flash[:notice] = I18n.t('tradeline.deleted')
    respond_to do |format|
      format.html { redirect_to trade_lines_url }
      format.js {}
    end
  end

  private

  def set_trade_line
    @trade_line = TradeLine.find(params[:id])
  end

  def trade_line_params
    params.require(:trade_line).permit(:slots, :bank, :credit_limit, :history,
                                       :statement_date, :state_id, :special_add,
                                       :ssn_req, :dl_req, :price, :is_active, :expiration_date)
  end
end
