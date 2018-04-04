class CreateBankingInformation < ActiveRecord::Migration[5.0]
  def change
    create_table :banking_informations do |t|
      t.string :account_number
      t.string :routing_info
      t.string :bank_name
      t.string :driving_license
      t.belongs_to :user, index: { unique: true }, foreign_key: true
      
      t.timestamps
    end

    add_reference :users, :banking_information, foreign_key: true

  end
end
