class Book < ApplicationRecord
  has_many :summaries, dependent: :destroy
  has_many :memos, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :title, presence: true
  validates :image_url, presence: true
  validates :url, presence: true
  validates :author, presence: true
  validates :publisher, presence: true
  validates :isbn, presence: true

  scope :get_by_title, -> (title) { where('title LIKE ?', "%#{title}%")}
  scope :get_by_author, -> (author) { where('author LIKE ?', "%#{author}%")}

  def find_videos(keyword, after: 10.years.ago, before: Time.now)
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
