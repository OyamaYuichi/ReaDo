class SummariesController < ApplicationController
  before_action :set_summary, only: [:show, :edit, :update, :destroy]
  before_action :search, only: [:index]

  def search
    if params[:title].nil?

      searches = RakutenWebService::Books::Book.search(title: "Ruby")
    else
      searches = RakutenWebService::Books::Book.search(title: params[:title])
      # redirect_to request.referer
    end
      searches_hits = searches.response
      # binding.pry
      @searches = []

        searches_hits.each do |item|
          book = item
          @searches << book
        end
      @searches = Kaminari.paginate_array(@searches).page(params[:page]).per(3)

      @hit_count = searches.response["count"]

      # redirect_to request.referer
  end

  def index
    @summaries = Summary.all
  end

  def new
    @summary = Summary.new
    @book = Book.find(params[:book_id])
  end

  def create
    # @feed = current_user.feeds.build(feed_params)
    @book = Book.find(params[:book_id])
    @summary = @book.summaries.build(summary_params)
    @summary.user_id = current_user.id
    # @summary = Summary.new(summary_params)
    if params[:back]
      render :new
    else
      if @summary.save
        redirect_to summaries_path, notice: "投稿しました！"
      else
        render :new
      end
    end
  end

  def show
    @favorite = current_user.favorites.find_by(summary_id: @summary.id)
  end

  def edit
  end

  def update
    if @summary.update(summary_params)
      redirect_to summaries_path, notice: "編集しました！"
    else
      render :edit
    end
  end

  def destroy
    @summary.destroy
    redirect_to summaries_path, notice: "削除しました！"
  end

  # def confirm
  #   @mouth = Mouth.new(mouth_params)
  #   render :new if @mouth.invalid?
  # end

  private
  def summary_params
    params.require(:summary).permit(:book_id, :content)
  end

  def set_summary
    @summary = Summary.find(params[:id])
  end
end
