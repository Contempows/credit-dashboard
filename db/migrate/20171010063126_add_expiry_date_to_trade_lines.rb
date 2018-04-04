class AddExpiryDateToTradeLines < ActiveRecord::Migration[5.0]
  def change
    add_column :trade_lines, :expiration_date, :date, default: ''
  end
end
