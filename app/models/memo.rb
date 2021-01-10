class Memo < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :content, presence: true
  validates :action_plan, presence: true
  validates :email_send, inclusion: [true, false]

  has_rich_text :content
  has_rich_text :action_plan

  def self.calc_level(current_user)
    current_user.summaries.count * 0.8 + current_user.memos.count * 0.3 + current_user.reviews.count * 0.1 + current_user.comments.count * 0.1
  end
end
