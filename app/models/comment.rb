class Comment < ApplicationRecord
  belongs_to :summary
  belongs_to :user

  validates :content, presence: true
end
