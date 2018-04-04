class AddAttachmentToRefunds < ActiveRecord::Migration[5.0]
  def change
    add_column :refunds, :attachment, :string
  end
end
