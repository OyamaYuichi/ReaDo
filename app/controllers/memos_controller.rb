class MemosController < ApplicationController
  before_action :set_memo, only: [:show, :edit, :update, :destroy]

  def index
    @memos = current_user.memos
  end

  def new
    @memo = Memo.new
    @book = Book.find(params[:book_id])
  end

  def create
    # @feed = current_user.feeds.build(feed_params)
    @book = Book.find(params[:book_id])
    @memo = @book.memos.build(memo_params)
    @memo.user_id = current_user.id
    if params[:back]
      render :new
    else
      if @memo.save
        redirect_to memos_path, notice: "投稿しました！"
      else
        render :new
      end
    end
  end

  def show
  end

  def edit
    @book = @memo.book
  end

  def update
    if @memo.update(memo_params)
      redirect_to memos_path, notice: "編集しました！"
    else
      render :edit
    end
  end

  def destroy
    @memo.destroy
    redirect_to memos_path, notice: "削除しました！"
  end

  private
  def memo_params
    params.require(:memo).permit(:book_id, :content, :action_plan)
  end

  def set_memo
    @memo = Memo.find(params[:id])
  end
end
