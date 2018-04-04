class AddStatusColumnToSsn < ActiveRecord::Migration[5.0]
  def change
    add_column :ssns, :status, :integer
  end
end
