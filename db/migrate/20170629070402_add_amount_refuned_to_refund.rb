class AddAmountRefunedToRefund < ActiveRecord::Migration[5.0]
  def change
    add_column :refunds, :amount_refunded, :decimal
  end
end
