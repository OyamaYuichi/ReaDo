class AddBookRefToSummaries < ActiveRecord::Migration[5.2]
  def change
    add_reference :summaries, :book, foreign_key: true
  end
end
