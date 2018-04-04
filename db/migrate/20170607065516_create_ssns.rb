class CreateSsns < ActiveRecord::Migration[5.0]
  def change
    create_table :ssns do |t|
      t.integer :user_id
      t.string :ssnorcpn

      t.timestamps
    end
  end
end
