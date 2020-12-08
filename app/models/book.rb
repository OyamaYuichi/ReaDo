class Book < ApplicationRecord
  has_many :summaries, dependent: :destroy
  has_many :memos, dependent: :destroy
  has_many :reviews, dependent: :destroy
end
