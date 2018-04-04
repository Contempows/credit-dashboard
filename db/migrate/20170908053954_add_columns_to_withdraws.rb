class AddColumnsToWithdraws < ActiveRecord::Migration[5.0]
  def change
    add_column :withdraws, :payee, :string
    add_column :withdraws, :address, :text
  end
end
