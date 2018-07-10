module ApplicationHelper
  def parse_booleans(value)
    value ? 'Yes' : 'No'
  end

  def month_year(value)
    return '' if value.nil?
    value.strftime('%m/%Y')
  end

  def month_date_full_year(value)
    return '' if value.nil?
    value.strftime('%m/%d/%Y')
  end

  def month_date_year(date)
    return '' if date.nil?
    date.strftime('%m/%d/%y')
  end

  def boolean_options
    [['Yes', true], ['No', false]]
  end

  def month_date_and_year(date)
    date.strftime('%b %d, %Y')
  end

  def date_to_years(date)
    date2 = Time.zone.now.to_date
    val = (date2.year * 12 + date2.month) - (date.year * 12 + date.month)
    val = (val / 12.0)
    val % 1 >= 0.5 ? val.to_i + 0.5 : val.to_i
  end

  def user_wallet_balance_precision(balance)
    (balance - balance.to_i).zero? ? 0 : 2
  end

  def ref_text(klass)
    case klass
    when 'purchase'
      'Payment Ref.'
    when 'deposit'
      'Deposit Ref.'
    when 'refund'
      'Refund Ref.'
    else
      'Withdrawal Ref.'
    end
  end

  def can_delete_au(user)
    user.purchases.empty? && user.deposits.empty? && user.withdraws.empty?
  end

  def cannot_refund(purchase)
    (purchase.refunds.pluck(:status) & %w[accepted partially_accepted]).any?
  end

  def get_states_list
    ['AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'PR', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY']
  end
end
