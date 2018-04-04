class CreateLedgerEntries < ActiveRecord::Migration[5.0]
  def up
    create_table :ledger_entries do |t|
      t.decimal :credit, default: 0.0
      t.decimal :debit, default: 0.0
      t.decimal :balance, default: 0.0
      t.integer :user_id
      t.integer :entry_id
      t.string :entry_type

      t.timestamps
    end
  end
  def down
    drop_table :ledger_entries
  end
end
