class AddUserBookRefToMemos < ActiveRecord::Migration[5.2]
  def change
    add_reference :memos, :user, foreign_key: true
    add_reference :memos, :book, foreign_key: true
  end
end
