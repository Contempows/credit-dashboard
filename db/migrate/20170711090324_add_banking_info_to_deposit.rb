class AddBankingInfoToDeposit < ActiveRecord::Migration[5.0]
  def change
    add_column :deposits, :banking_information_id, :integer, default: nil
  end
end
