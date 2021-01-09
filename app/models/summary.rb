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

  class << self
    def search(title, author, category, follow, current_user)
      if title.present? && author.present? && category.present? && follow == "true"
        summaries = title_author_category_follow(title, author, category, current_user)
      elsif title.present? && author.present? && category.present?
        summaries = title_author_category(title, author, category)
      elsif title.present? && author.present? && follow == "true"
        summaries = title_author_follow(title, author, current_user)
      elsif title.present? && category.present? && follow == "true"
        summaries = title_category_follow(title, category, current_user)
      elsif author.present? && category.present? && follow == "true"
        summaries = author_category_follow(author, category, current_user)
      elsif title.present? && author.present?
        summaries = title_author(title, author)
      elsif title.present? && category.present?
        summaries = title_category(title, category)
      elsif title.present? && follow == "true"
        summaries = title_follow(title, current_user)
      elsif author.present? && category.present?
        summaries = author_category(author, category)
      elsif author.present? && follow == "true"
        summaries = author_follow(author, current_user)
      elsif category.present? && follow == "true"
        summaries = category_follow(category, current_user)
      elsif title.present?
        summaries = title(title)
      elsif author.present?
        summaries = author(author)
      elsif category.present?
        summaries = category(category)
      else follow == "true"
        summaries = follow(current_user)
      end
      summaries = Kaminari.paginate_array(summaries)
    end

    def title_author_category_follow(title, author, category, current_user)
      books =  Book.get_by_title(title).get_by_author(author)
      search_category_follow(category, current_user, books)
    end

    def title_author_category(title, author, category)
      books =  Book.get_by_title(title).get_by_author(author)
      search_category(category, books)
    end

    def title_author_follow(title, author, current_user)
      books =  Book.get_by_title(title).get_by_author(author)
      search_summaries = book_sort(books)
      search_follow(current_user, search_summaries)
    end

    def title_category_follow(title, category, current_user)
      books =  Book.get_by_title(title)
      search_category_follow(category, current_user, books)
    end

    def author_category_follow(author, category, current_user)
      books =  Book.get_by_author(author)
      search_category_follow(category, current_user, books)
    end

    def title_author(title, author)
      books =  Book.get_by_title(title).get_by_author(author)
      summaries = book_sort(books)
    end

    def title_category(title, category)
      books =  Book.get_by_title(title)
      search_category(category, books)
    end

    def title_follow(title, current_user)
      books =  Book.get_by_title(title)
      search_summaries = book_sort(books)
      search_follow(current_user, search_summaries)
    end

    def author_category(author, category)
      books =  Book.get_by_author(author)
      search_category(category, books)
    end

    def author_follow(author, current_user)
      books =  Book.get_by_author(author)
      search_summaries = book_sort(books)
      search_follow(current_user, search_summaries)
    end

    def category_follow(category, current_user)
      search_summaries =  Summary.get_by_category(category)
      search_follow(current_user, search_summaries)
    end

    def title(title)
      books =  Book.get_by_title(title)
      summaries = book_sort(books)
    end

    def author(author)
      books =  Book.get_by_author(author)
      summaries = book_sort(books)
    end

    def category(category)
      summaries =  Summary.get_by_category(category)
    end

    def follow(current_user)
      follow_users = current_user.following
      summaries = []
      follow_users.each do |follow_user|
        summaries << follow_user.summaries
      end
      summaries = summaries.flatten.sort do |a, b|
        b[:created_at] <=> a[:created_at]
      end
    end

    def search_category_follow(category, current_user, books)
      search_summaries = book_sort(books)
      summaries = []
      search_summaries.each do |summary|
        if summary.category == category && current_user.following.ids.include?(summary.user_id)
          summaries << summary
        end
      end
      summaries
    end

    def search_category(category, books)
      search_summaries = book_sort(books)
      summaries = []
      search_summaries.each do |summary|
        if summary.category == category
          summaries << summary
        end
      end
      summaries
    end

    def search_follow(current_user, search_summaries)
      summaries = []
      search_summaries.each do |summary|
        if current_user.following.ids.include?(summary.user_id)
          summaries << summary
        end
      end
      summaries
    end

    def book_sort(books)
      summaries = []
      books.each do |book|
        summaries << book.summaries
      end
      search_summaries = summaries.flatten.sort do |a, b|
        b[:created_at] <=> a[:created_at]
      end
    end

    def calc_level(current_user)
      read_level = current_user.summaries.count * 0.6
                    + current_user.memos.count * 0.2
                    + current_user.reviews.count * 0.1
                    + current_user.comments.count * 0.1
    end

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
end
