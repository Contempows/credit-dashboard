class SwitchColumnsInBankingInformation < ActiveRecord::Migration[5.0]
  def change
    add_column :banking_informations, :account_name, :string
  end
end
