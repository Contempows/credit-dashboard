class CreateStates < ActiveRecord::Migration[5.0]
  def change
    create_table :states do |t|
      t.string :name, default: ''
      t.string :short_code, default: ''

      t.timestamps
    end
  end
end
