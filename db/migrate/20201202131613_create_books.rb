class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title
      t.text :image_url
      t.text :url
      t.string :author
      t.string :publisher
      t.string :isbn
      t.timestamps
    end
  end
end
