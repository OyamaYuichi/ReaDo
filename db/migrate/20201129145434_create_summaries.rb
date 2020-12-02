class CreateSummaries < ActiveRecord::Migration[5.2]
  def change
    create_table :summaries do |t|
      t.string :book_title
      t.text :book_image
      t.text :book_url
      t.string :book_author
      t.string :book_publisher
      t.timestamps
    end
  end
end
