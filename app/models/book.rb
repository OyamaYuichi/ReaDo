class Book < ApplicationRecord
  has_many :summaries, dependent: :destroy
end
