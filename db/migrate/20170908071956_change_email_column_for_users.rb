class ChangeEmailColumnForUsers < ActiveRecord::Migration[5.0]
  def change
    change_column_null :users, :email, true
    remove_index :users, :email
  end
end
