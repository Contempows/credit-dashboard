class CreatePurchases < ActiveRecord::Migration[5.0]
  def change
    create_table :purchases do |t|
      t.string :ref
      t.decimal :amount
      t.integer :user_id
      t.integer :trade_line_id
      t.integer :status
      t.integer :purchased_by_id

      t.timestamps
    end
  end
end
