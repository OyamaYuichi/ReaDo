class SummariesController < ApplicationController
  before_action :set_summary, only: [:show, :edit, :update, :destroy]

  def index
    @q = Summary.ransack(params[:q])
    @summaries = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(5)
    # @youtube_data = find_videos("要約")
    # if params[:q].present?
    #   if params[:q][:book_title_cont].present?
    #     @youtube_data = find_videos(params[:q][:book_title_cont])
    #   else
    #     @youtube_data = find_videos("要約")
    #   end
    # end
  end

  def new
    @summary = Summary.new
    @book = Book.find(params[:book_id])
  end

  def create
    @book = Book.find(params[:book_id])
    @summary = @book.summaries.build(summary_params)
    @summary.user_id = current_user.id
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
    @comments = @summary.comments
    @comment = @summary.comments.build
  end

  def edit
    @book = @summary.book
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
  def summary_params
    params.require(:summary).permit(:book_id, :content, :category)
  end

  def set_summary
    @summary = Summary.find(params[:id])
  end
end
