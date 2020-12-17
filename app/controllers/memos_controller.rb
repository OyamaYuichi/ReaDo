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
  end

  def edit
    @book = @memo.book
  end

  def update
    if @memo.update(memo_params)
      UserMailer.notify_user().deliver
      redirect_to memos_path, notice: "編集しました！"
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
