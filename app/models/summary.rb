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

  def self.calc_level(current_user)
    read_level = current_user.summaries.count * 0.6
                  + current_user.memos.count * 0.2
                  + current_user.reviews.count * 0.1
                  + current_user.comments.count * 0.1
  end

  def self.find_videos(keyword, after: 10.years.ago, before: Time.now)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = ENV["YOUTUBE_APIKEY"]

    next_page_token = nil
    opt = {
      q: keyword,
      type: 'video',
      max_results: 10,
      order: :relevance,
      page_token: next_page_token,
      published_after: after.iso8601,
      published_before: before.iso8601
    }
    begin
      service.list_searches(:snippet, opt)
    rescue
    end
  end

end
