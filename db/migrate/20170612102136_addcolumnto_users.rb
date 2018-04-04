class AddcolumntoUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :invited_by_id, :integer
  end
end
