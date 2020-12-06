class AddGenreToSummaries < ActiveRecord::Migration[5.2]
  def change
    add_column :summaries, :category, :integer, null: false
    add_index :summaries, :category
  end
end
