class BooksController < ApplicationController
  def new
    @items = []

    @title = params[:title]
    if @title.present?
      results = RakutenWebService::Books::Book.search({
        title: @title,
        # booksGenreId: '001004',
        hits: 20,
      })

      results.each do |result|
        item = Book.new(read(result))
        @items << item
      end
    end
    @items = Kaminari.paginate_array(@items).page(params[:page]).per(3)
  end

  def create
    @item = Book.find_or_initialize_by(isbn: params[:isbn])

    unless @item.persisted?
      results = RakutenWebService::Books::Book.search(isbn: @item.isbn)
      @item = Book.new(read(results.first))
      @item.save
    end
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
end
