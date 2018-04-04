class AddActiveToTradeline < ActiveRecord::Migration[5.0]
  def change
    add_column :trade_lines, :is_active, :boolean, default: false
  end
end
