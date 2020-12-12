class Book < ApplicationRecord
  has_many :summaries, dependent: :destroy
  has_many :memos, dependent: :destroy
  has_many :reviews, dependent: :destroy

  scope :get_by_title, -> (title) { where('title LIKE ?', "%#{title}%")}
  scope :get_by_author, -> (author) { where('author LIKE ?', "%#{author}%")}
end
