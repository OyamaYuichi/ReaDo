class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :content, presence: true

  def self.calc_level(current_user)
    read_level = current_user.summaries.count * 0.6
                  + current_user.memos.count * 0.2
                  + current_user.reviews.count * 0.1
                  + current_user.comments.count * 0.1
  end
end
