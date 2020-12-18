class Memo < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :content, presence: true
  validates :action_plan, presence: true
  validates :email_send, inclusion: [true, false]
end
