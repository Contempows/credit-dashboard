class AddFileToPurchases < ActiveRecord::Migration[5.0]
  def change
    add_column :purchases, :file, :string
  end
end
