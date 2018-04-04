class AddDefaultValuesToTradeLineColumns < ActiveRecord::Migration[5.0]
  def change
    change_column :trade_lines, :ssn_req, :boolean, default: false
    change_column :trade_lines, :dl_req, :boolean, default: false
    change_column :trade_lines, :special_add, :boolean, default: false
  end
end
