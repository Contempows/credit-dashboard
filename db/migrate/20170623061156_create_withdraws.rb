class CreateWithdraws < ActiveRecord::Migration[5.0]
  def change
    create_table :withdraws do |t|
      t.decimal :amount, default: 0.0
      t.integer :withdraw_by_id
      t.integer :status, default: 0
      t.string  :ref, default: ''

      t.timestamps
    end
  end
end
