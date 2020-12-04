class Summary < ApplicationRecord
  has_rich_text :content
  belongs_to :book
  belongs_to :user

  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user
end
