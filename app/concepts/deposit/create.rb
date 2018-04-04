class Deposit::Create < Trailblazer::Operation
  step :process!

  def process!(options, params:, user:, current_user:, **)
    options['model'] = user.deposits.build(params)
    if current_user.au?
      if params['date_of_deposit'].present?
        month, day, year = params['date_of_deposit'].split('/')
        date = Date.new(2000 + year.to_i, month.to_i, day.to_i)
      end
      options['model'].date_of_deposit = date
    elsif (params['amount'].to_f + user.wallet_balance.to_f).negative?
      options['model'].errors.add(:amount, "User doesn't have required wallet balance to deduct")
      return
    end
    options['model'].save
  end
end
