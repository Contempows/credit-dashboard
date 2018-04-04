class TradeLine::Create < Trailblazer::Operation
  step :process!

  def process!(options, params:, **)
    options['model'] = params.delete('trade_line')
    history = params['history']
    expiration_date = params['expiration_date']
    if history.present?
      month, year = history.split('/')
      history = Date.new(year.to_i, month.to_i, 1)
    end
    if expiration_date.present?
      month, day, year = expiration_date.split('/')
      expiration_date = Date.new(year.to_i, month.to_i, day.to_i)
    end
    params[:special_add] = false if params[:special_add].blank?
    params[:ssn_req] = false if params[:ssn_req].blank?
    params[:dl_req] = false if params[:dl_req].blank?
    options['model'].attributes = params.merge(history: history, expiration_date: expiration_date)

    options['states'] = State.pluck(:name, :id)
    options['trade_lines'] = TradeLine.includes(:state)
                                      .paginate_and_order(params[:page], 15)
    options['model'].save
  end
end
