class ChangeColumnOfTradeLines < ActiveRecord::Migration[5.0]
  def change
    remove_column :trade_lines, :statement_date
    add_column :trade_lines, :statement_date, :integer, default: nil
  end
end
