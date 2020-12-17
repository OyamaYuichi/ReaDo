class Summary < ApplicationRecord
  has_rich_text :content
  belongs_to :book
  belongs_to :user

  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user
  has_many :comments, dependent: :destroy

  validates :category, presence: true
  validates :content, presence: true

  enum category: {
    skill_up: 0, self_help: 1, time_management: 2, management: 3, management_strategy: 4, entrepreneurship: 5, human_resources: 6, marketing: 7, industry: 8, global: 9,
    economy: 10, finance: 11, technology: 12, science: 13, liberal_arts:14, health: 15,
    trend: 16, other: 17
  }

  scope :get_by_category, -> (category) { where(category: category)}
end
