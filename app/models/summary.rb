class Summary < ApplicationRecord
  has_rich_text :content
  belongs_to :book
  belongs_to :user
end
