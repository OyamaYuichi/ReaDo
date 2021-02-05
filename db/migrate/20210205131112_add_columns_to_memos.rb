class AddColumnsToMemos < ActiveRecord::Migration[5.2]
  def change
    add_column :memos, :content, :text
    add_column :memos, :action_plan, :text
  end
end
