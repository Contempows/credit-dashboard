class Removebankinginformationidfromusers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :banking_information_id
  end
end
