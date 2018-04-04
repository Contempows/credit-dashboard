class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :date_of_birth, :date
    add_column :users, :mother_maiden_name, :string
  end
end
