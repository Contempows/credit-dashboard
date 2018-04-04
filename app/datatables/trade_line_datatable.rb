class TradeLineDatatable < AjaxDatatablesRails::Base
  def_delegators :@view, :params, :number_to_currency, :date_to_years,
                 :parse_booleans, :current_user, :current_ability

  def sortable_columns
    @sortable_columns ||= []
  end

  def as_json(_options = {})
    {
      sEcho: params[:draw].to_i,
      iTotalRecords: TradeLine.count,
      iTotalDisplayRecords: trade_lines.count,
      aaData: data
    }
  end

  def data
    data = []
    if trade_lines.present?
      trade_lines.each do |m|
        str = m.is_active? ? 'Active' : 'Inactive' if @view.current_user.staff?
        temp_array = [
          m.slots,
          m.bank,
          number_to_currency(m.credit_limit),
          date_to_years(m.history).to_s + ' yrs',
          m.statement_date.ordinalize,
          m.state.short_code,
          parse_booleans(m.special_add),
          parse_booleans(m.ssn_req),
          parse_booleans(m.dl_req),
          number_to_currency(m.price, precision: 2),
          m.id
        ]
        trade_line_array = current_user.staff? ? temp_array.insert(10, str).insert(0, m.id) : temp_array
        data.push(trade_line_array)
      end
    end
    data
  end

  private

  def trade_lines
    @trade_lines ||= fetch_trade_lines
  end

  def fetch_trade_lines
    trade_lines = search_chars(params)
    return trade_lines unless trade_lines.any?
    trade_lines.order("#{sort_column} " "#{sort_direction}")
               .accessible_by(current_ability)
               .page(params[:page])
               .per_page(30)
               .offset(params[:start])
  end

  def sort_column
    columns = { '0' => 'slots', '1' => 'bank',
                '2' => 'credit_limit', '3' => 'history',
                '4' => 'statement_date', '9' => 'price' }
    columns[params.dig('order', '0', 'column')]
  end

  def sort_direction
    params.dig('order', '0', 'dir') == 'asc' ? 'ASC' : 'DESC'
  end

  def search_chars(params)
    trade_lines = TradeLine.includes(:state)
    trade_lines = trade_lines.where('bank in (?)', params[:bank]) if params[:bank].present?
    trade_lines = trade_lines.where('credit_limit >= ?',
                                    params[:min_credit_limit].presence || 0.0)
    trade_lines = trade_lines.where('price <= ?', params[:max_price]) if params[:max_price].present?

    if params[:state].present?
      trade_lines = trade_lines.joins(:state)
                               .where('states.id = ?', params[:state].to_i)
    end
    trade_lines = trade_lines.where(special_add: params[:special_add].presence || [true, false])
                             .where(ssn_req: params[:ssn_req].presence || [true, false])
                             .where(dl_req: params[:dl_req].presence || [true, false])
    trade_lines
  end
end
