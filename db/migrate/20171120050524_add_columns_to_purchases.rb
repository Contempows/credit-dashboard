class AddColumnsToPurchases < ActiveRecord::Migration[5.0]
  def change
    add_column :purchases, :file_for_ssn, :string
    add_column :purchases, :file_for_dl, :string
    rename_column :purchases, :file, :file_for_special_add
  end
end
