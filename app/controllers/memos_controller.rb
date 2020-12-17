class MemosController < ApplicationController
  before_action :set_memo, only: [:show, :edit, :update, :destroy]

  def index
    @memos = current_user.memos.includes(:book)
  end

  def new
    @memo = Memo.new
    @book = Book.find(params[:book_id])
  end

  def create
    @book = Book.find(params[:book_id])
    @memo = @book.memos.build(memo_params)
    @memo.user_id = current_user.id
    if @memo.save
      UserMailer.notify_user().deliver
      calc_level
      current_user.update(level: @read_level.floor)
      redirect_to summaries_path, notice: "投稿しました！"
    else
      render :new
    end
  end


  def show
    category = @memo.book.summaries.pluck(:category)
    if category.count < 1
      @category_1 = @memo.book.summaries.categories_i18n.first[1]
    elsif category.count < 2
      @category_1 = @memo.book.summaries.first.category_i18n
    elsif category.count < 3
      @category_1 = @memo.book.summaries.first.category_i18n
      @category_2 = @memo.book.summaries.second.category_i18n
    else
      @category_1 = @memo.book.summaries.first.category_i18n
      @category_2 = @memo.book.summaries.second.category_i18n
      @category_3 = @memo.book.summaries.third.category_i18n
    end
  end

  def edit
    @book = @memo.book
    category = @book.summaries.pluck(:category)
    if category.count < 1
      @category_1 = @book.summaries.categories_i18n.first[1]
    elsif category.count < 2
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

  def update
    if @memo.update(memo_params)
      UserMailer.notify_user().deliver
      redirect_to memo_path(@memo), notice: "編集しました！"
    else
      render :edit
    end
  end

  def destroy
    @memo.destroy
    UserMailer.notify_user().deliver
    calc_level
    current_user.update(level: @read_level.floor)
    redirect_to memos_path, notice: "削除しました！"
  end

  def calc_level
    @read_level = current_user.summaries.count * 0.6
                  + current_user.memos.count * 0.2
                  + current_user.reviews.count * 0.1
                  + current_user.comments.count * 0.1
  end

  private
  def memo_params
    params.require(:memo).permit(:content, :action_plan, :email_send)
  end

  def set_memo
    @memo = Memo.find(params[:id])
  end
end
