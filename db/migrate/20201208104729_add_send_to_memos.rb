class AddSendToMemos < ActiveRecord::Migration[5.2]
  def change
    add_column :memos, :send, :boolean, default: false, null: false
  end
end
