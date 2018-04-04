class RemoveColumnInBankingInformation < ActiveRecord::Migration[5.0]
  def change
    remove_column :banking_informations, :driving_license
  end
end
