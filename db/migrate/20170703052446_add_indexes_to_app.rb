class AddIndexesToApp < ActiveRecord::Migration[5.0]
  def change
    add_index :deposits, :user_id
    add_index :purchases, :trade_line_id
    add_index :purchases, :purchased_by_id
    add_index :refunds, :purchase_id
    add_index :users, :status
    add_index :withdraws, :withdraw_by_id
  end
end
