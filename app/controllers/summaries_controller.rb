class SummariesController < ApplicationController
  before_action :set_summary, only: [:show, :edit, :update, :destroy]
  before_action :search, only: [:index, :new]

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
      @searches = Kaminari.paginate_array(@searches).page(params[:page]).per(10)

      @hit_count = searches.response["count"]

      # redirect_to request.referer
  end

  def index
    @summaries = Summary.all

    # if params[:title].nil?

    #   searches = RakutenWebService::Books::Book.search(title: "Ruby")
    # else
    #   searches = RakutenWebService::Books::Book.search(title: params[:title])
    # end
    #   searches_hits = searches.response
    #   # binding.pry
    #   @searches = []

    #     searches_hits.each do |item|
    #       book = item
    #       @searches << book
    #     end
    #   @searches = Kaminari.paginate_array(@searches).page(params[:page]).per(10)

    #   @hit_count = searches.response["count"]
  end

  def new
    @summary = Summary.new

    # if params[:title].nil?

    #   searches = RakutenWebService::Books::Book.search(title: "Ruby")
    # else
    #   searches = RakutenWebService::Books::Book.search(title: params[:title])
    # end
    #   searches_hits = searches.response
    #   # binding.pry
    #   @searches = []

    #     searches_hits.each do |item|
    #       book = item
    #       @searches << book
    #     end
    #   @searches = Kaminari.paginate_array(@searches).page(params[:page]).per(3)
  end

  def create
    @summary = Summary.new(summary_params)
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
    params.require(:summary).permit(:content)
  end

  def set_summary
    @summary = Summary.find(params[:id])
  end
end
