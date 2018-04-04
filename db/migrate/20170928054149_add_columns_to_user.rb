class AddColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :city, :string unless column_exists? :users, :city
    add_column :users, :state, :string unless column_exists? :users, :state
  end
end
