class AddContentToSummaries < ActiveRecord::Migration[5.2]
  def change
    add_column :summaries, :content, :text
  end
end
