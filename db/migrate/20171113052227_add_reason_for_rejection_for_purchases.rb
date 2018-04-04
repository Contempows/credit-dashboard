class AddReasonForRejectionForPurchases < ActiveRecord::Migration[5.0]
  def change
    add_column :purchases, :reason_for_rejection, :string, default: ''
  end
end
