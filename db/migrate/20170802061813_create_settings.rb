class CreateSettings < ActiveRecord::Migration[5.0]
  def up
    create_table :settings do |t|
      t.decimal :ssn_charge, default: 0.0

      t.timestamps
    end
  end

  def down
    drop_table :settings
  end
end
