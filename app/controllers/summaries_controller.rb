class SummariesController < ApplicationController
  before_action :set_summary, only: [:show, :edit, :update, :destroy]

  def index
    search
    @summaries = @summaries.page(params[:page]).per(10)
    @summary_1 = Summary.find(rand(1..(Summary.count)))
    @summary_2 = Summary.find(rand(1..(Summary.count)))
    @summary_3 = Summary.find(rand(1..(Summary.count)))
    @summary_4 = Summary.find(rand(1..(Summary.count)))
    @summary_5 = Summary.find(rand(1..(Summary.count)))
    # @youtube_data = find_videos("要約")
    # if params[:q].present?
    #   if params[:q][:book_title_cont].present?
    #     @youtube_data = find_videos(params[:q][:book_title_cont])
    #   else
    #     @youtube_data = find_videos("要約")
    #   end
    # end
  end

  def search
    if params[:title].present? && params[:author].present? && params[:category].present? && params[:follow] == "true"
      @books =  Book.get_by_title(params[:title]).get_by_author(params[:author])
      book_sort
      summaries = []
      @summaries.each do |summary|
        if summary.category == params[:category] && current_user.following.ids.include?(summary.user_id)
          summaries << summary
        end
      end
      @summaries = Kaminari.paginate_array(summaries)
      @checked_follow = true

    elsif params[:title].present? && params[:author].present? && params[:category].present?
      @books =  Book.get_by_title(params[:title]).get_by_author(params[:author])
      book_sort
      summaries = []
      @summaries.each do |summary|
        if summary.category == params[:category]
          summaries << summary
        end
      end
      @summaries = Kaminari.paginate_array(summaries)

    elsif params[:title].present? && params[:author].present? && params[:follow] == "true"
      @books =  Book.get_by_title(params[:title]).get_by_author(params[:author])
      book_sort
      summaries = []
      @summaries.each do |summary|
        if current_user.following.ids.include?(summary.user_id)
          summaries << summary
        end
      end
      @summaries = Kaminari.paginate_array(summaries)
      @checked_follow = true

    elsif params[:title].present? && params[:category].present? && params[:follow] == "true"
      @books =  Book.get_by_title(params[:title])
      book_sort
      summaries = []
      @summaries.each do |summary|
        if summary.category == params[:category] && current_user.following.ids.include?(summary.user_id)
          summaries << summary
        end
      end
      @summaries = Kaminari.paginate_array(summaries)
      @checked_follow = true

    elsif params[:author].present? && params[:category].present? && params[:follow] == "true"
      @books =  Book.get_by_author(params[:author])
      book_sort
      summaries = []
      @summaries.each do |summary|
        if summary.category == params[:category] && current_user.following.ids.include?(summary.user_id)
          summaries << summary
        end
      end
      @summaries = Kaminari.paginate_array(summaries)
      @checked_follow = true

    elsif params[:title].present? && params[:author].present?
      @books =  Book.get_by_title(params[:title]).get_by_author(params[:author])
      book_sort
      @summaries = Kaminari.paginate_array(@summaries)

    elsif params[:title].present? && params[:category].present?
      @books =  Book.get_by_title(params[:title])
      book_sort
      summaries = []
      @summaries.each do |summary|
        if summary.category == params[:category]
          summaries << summary
        end
      end
      @summaries = Kaminari.paginate_array(summaries)

    elsif params[:title].present? && params[:follow] == "true"
      @books =  Book.get_by_title(params[:title])
      book_sort
      summaries = []
      @summaries.each do |summary|
        if current_user.following.ids.include?(summary.user_id)
          summaries << summary
        end
      end
      @summaries = Kaminari.paginate_array(summaries)
      @checked_follow = true

    elsif params[:author].present? && params[:category].present?
      @books =  Book.get_by_author(params[:author])
      book_sort
      summaries = []
      @summaries.each do |summary|
        if summary.category == params[:category]
          summaries << summary
        end
      end
      @summaries = Kaminari.paginate_array(summaries)
    elsif params[:author].present? && params[:follow] == "true"
      @books =  Book.get_by_author(params[:author])
      book_sort
      summaries = []
      @summaries.each do |summary|
        if current_user.following.ids.include?(summary.user_id)
          summaries << summary
        end
      end
      @summaries = Kaminari.paginate_array(summaries)
      @checked_follow = true

    elsif params[:category].present? && params[:follow] == "true"
      @summaries =  Summary.get_by_category(params[:category])
      summaries = []
      @summaries.each do |summary|
        if current_user.following.ids.include?(summary.user_id)
          summaries << summary
        end
      end
      @summaries = Kaminari.paginate_array(summaries)
      @checked_follow = true

    elsif params[:title].present?
      @books =  Book.get_by_title(params[:title])
      book_sort
      @summaries = Kaminari.paginate_array(@summaries)

    elsif params[:author].present?
      @books =  Book.get_by_author(params[:author])
      book_sort
      @summaries = Kaminari.paginate_array(@summaries)

    elsif params[:category].present?
      @summaries =  Summary.get_by_category(params[:category])
      @summaries = Kaminari.paginate_array(@summaries)

    elsif params[:follow] == "true"
      @follow_users = current_user.following
      @summaries = []
      @follow_users.each do |follow_user|
        @summaries << follow_user.summaries
      end
      @summaries = @summaries.flatten.sort do |a, b|
        b[:created_at] <=> a[:created_at]
      end
      @summaries = Kaminari.paginate_array(@summaries)
      @checked_follow = true
    else
      @summaries = Summary.all.order(created_at: :desc)
    end
  end

  def book_sort
    @summaries = []
    @books.each do |book|
      @summaries << book.summaries
    end
    @summaries = @summaries.flatten.sort do |a, b|
      b[:created_at] <=> a[:created_at]
    end
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
