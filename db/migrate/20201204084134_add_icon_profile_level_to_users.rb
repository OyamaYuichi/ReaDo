class AddIconProfileLevelToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :icon, :text
    add_column :users, :profile, :string, default: "こんにちは！"
    add_column :users, :level, :integer, default: 0
  end
end
