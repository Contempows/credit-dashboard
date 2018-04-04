class CreateTradeLines < ActiveRecord::Migration[5.0]
  def change
    create_table :trade_lines do |t|
      t.integer :slots, default: 0
      t.string :bank, default: ''
      t.decimal :credit_limit, default: 0.0
      t.date :history
      t.date :statement_date
      t.integer :state_id
      t.boolean :special_add, default: false
      t.boolean :ssn_req, default: false
      t.boolean :dl_req, default: false
      t.decimal :price, default: 0.0

      t.timestamps
    end
  end
end
