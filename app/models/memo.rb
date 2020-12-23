class Memo < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :content, presence: true
  validates :action_plan, presence: true
  validates :email_send, inclusion: [true, false]

  has_rich_text :content
  has_rich_text :action_plan
end
