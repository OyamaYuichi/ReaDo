class RemoveContentAndActionPlanFromMemos < ActiveRecord::Migration[5.2]
  def up
    remove_column :memos, :content
    remove_column :memos, :action_plan
  end

  def down
    add_column :memos, :content, :text
    add_column :memos, :action_plan, :text
  end
end
