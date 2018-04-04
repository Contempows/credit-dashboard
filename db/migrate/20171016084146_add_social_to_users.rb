class AddSocialToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :social, :string, default: ''
  end
end
