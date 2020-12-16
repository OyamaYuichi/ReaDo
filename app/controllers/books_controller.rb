class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def new
    @books = []

    if params[:book_title].present?
      @title = params[:book_title]
      if @title.present?
        results = RakutenWebService::Books::Book.search({
          title: @title,
          hits: 20,
        })

        results.each do |result|
          book = Book.new(read(result))
          @books << book
        end
      end
    else
      @books = Book.all
    end

    @books = Kaminari.paginate_array(@books).page(params[:page]).per(10)
  end

  def create
    @book = Book.find_or_initialize_by(isbn: params[:isbn])

    unless @book.persisted?
      results = RakutenWebService::Books::Book.search(isbn: @book.isbn)
      @book = Book.new(read(results.first))
      @book.save
    end
    if params[:commit] == "要約"
      redirect_to new_book_summary_path(@book)
    else
      redirect_to new_book_memo_path(@book)
    end
  end

  def show
    @book = Book.find(params[:id])
    @reviews = @book.reviews.order(created_at: :desc)
    @review = @book.reviews.build
    @summaries = @book.summaries.order(created_at: :desc).page(params[:page]).per(20)
    #@youtube_data = find_videos(@book.title)
    category = @book.summaries.pluck(:category)
    if category.count < 2
      @category_1 = @book.summaries.first.category_i18n
    elsif category.count < 3
      @category_1 = @book.summaries.first.category_i18n
      @category_2 = @book.summaries.second.category_i18n
    else
      @category_1 = @book.summaries.first.category_i18n
      @category_2 = @book.summaries.second.category_i18n
      @category_3 = @book.summaries.third.category_i18n
    end
  end

  def find_videos(keyword, after: 10.years.ago, before: Time.now)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = ENV["YOUTUBE_APIKEY"]

    next_page_token = nil
    opt = {
      q: keyword,
      type: 'video',
      max_results: 1,
      order: :relevance,
      page_token: next_page_token,
      published_after: after.iso8601,
      published_before: before.iso8601
    }
    service.list_searches(:snippet, opt)
  end

  private

  def read(result)
    title = result['title']
    url = result['itemUrl']
    isbn = result['isbn']
    image_url = result['largeImageUrl'].gsub('?_ex=150x150', '')
    author = result['author']
    publisher = result['publisherName']

    {
      title: title,
      url: url,
      isbn: isbn,
      image_url: image_url,
      author: author,
      publisher: publisher
    }
  end

  def set_book
    @book = Book.find(params[:isbn])
  end
end
