class SummariesController < ApplicationController
  before_action :set_summary, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :search]

  def index
    if params[:search].present?
      summaries = Summary.search(params[:title], params[:author], params[:category], params[:follow], current_user)
    else
      summaries = Summary.all.order(created_at: :desc)
    end
    @summaries = summaries.page(params[:page]).per(30)
    if Summary.count > 4
      @summary_1 = Summary.all.sample
      @summary_2 = Summary.all.sample
      @summary_3 = Summary.all.sample
      @summary_4 = Summary.all.sample
      @summary_5 = Summary.all.sample
    end
    if params[:follow] == "true"
      @checked_follow = true
    end
    @youtube_data = Summary.find_videos("要約")
    if params[:title].present?
      @youtube_data = Summary.find_videos(params[:title])
    end
    @youtube_data_2 = ["N-fT1KjtGGA", "21aJYzS_Sxc", "cEj48QKHl3A", "SnG8OxmZOKU", "1h8vTIRJpdc", "wn9xelq7bLg", "KcUyFrb5cf4", "uWHH8PpnJtU", "7ZZwjUJdcoY", "ZsSZtKWgFmI"]
  end

  def new
    @summary = Summary.new
    @book = Book.find(params[:book_id])
  end

  def create
    @book = Book.find(params[:book_id])
    @summary = @book.summaries.build(summary_params)
    @summary.user_id = current_user.id
    if @summary.save
      read_level = Summary.calc_level(current_user)
      current_user.update(level: read_level.floor)
      redirect_to summaries_path, notice: t('view.create_notice')
    else
      render :new
    end
  end

  def show
    if current_user
      @favorite = current_user.favorites.find_by(summary_id: @summary.id)
    end
    @comments = @summary.comments.order(created_at: :desc)
    @comment = @summary.comments.build
  end

  def edit
    @book = @summary.book
  end

  def update
    if @summary.update(summary_params)
      redirect_to summaries_path, notice: t('view.edit_notice')
    else
      @book = @summary.book
      render :edit
    end
  end

  def destroy
    @summary.destroy
    read_level = Summary.calc_level(current_user)
    current_user.update(level: read_level.floor)
    redirect_to summaries_path, notice: t('view.destroy_notice')
  end

  private
  def summary_params
    params.require(:summary).permit(:book_id, :content, :category)
  end

  def set_summary
    @summary = Summary.find(params[:id])
  end
end
