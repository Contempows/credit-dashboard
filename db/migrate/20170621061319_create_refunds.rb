class CreateRefunds < ActiveRecord::Migration[5.0]
  def change
    create_table :refunds do |t|
      t.string :ref, default: ''
      t.string :reason, default: ''
      t.string :cm_service, default: ''
      t.string :cm_login, default: ''
      t.string :cm_password, default: ''
      t.decimal :amount, default: 0.0
      t.integer :status, default: 0
      t.string :reason_for_rejection, default: ''
      t.string :reason_for_inprogress, default: ''
      t.integer :purchase_id

      t.timestamps
    end
  end
end
