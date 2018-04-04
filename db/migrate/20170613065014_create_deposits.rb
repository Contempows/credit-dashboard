class CreateDeposits < ActiveRecord::Migration[5.0]
  def change
    create_table :deposits do |t|
      t.decimal :amount, default: 0.0
      t.date :date_of_deposit
      t.string :authorization_code, default: ''
      t.string :attachment, default: ''
      t.integer :status, default: 0
      t.integer :user_id

      t.timestamps
    end
  end
end
