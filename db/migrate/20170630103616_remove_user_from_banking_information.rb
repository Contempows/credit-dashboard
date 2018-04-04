class RemoveUserFromBankingInformation < ActiveRecord::Migration[5.0]
  def change
    remove_column :banking_informations, :user_id
  end
end
