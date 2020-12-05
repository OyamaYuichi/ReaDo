class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def new
    @books = []

    @title = params[:title]
    if @title.present?
      results = RakutenWebService::Books::Book.search({
        title: @title,
        # booksGenreId: '001004',
        hits: 20,
      })

      results.each do |result|
        book = Book.new(read(result))
        @books << book
      end
    end
    @books = Kaminari.paginate_array(@books).page(params[:page]).per(3)
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
  end

  private

  def read(result)
    title = result['title']
    url = result['itemUrl']
    isbn = result['isbn']
    image_url = result['mediumImageUrl'].gsub('?_ex=50x50', '')
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
