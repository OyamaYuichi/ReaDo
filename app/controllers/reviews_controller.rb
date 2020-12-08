class ReviewsController < ApplicationController
  before_action :set_book, only: [:create, :edit, :update]

  def create
    @book = Book.find(params[:book_id])
    @review = @book.reviews.build(review_params)
    @review.user_id = current_user.id
    respond_to do |format|
      if @review.save
        format.js { render :index }
      else
        format.html { redirect_to book_path(@book), notice: '投稿できませんでした...' }
      end
    end
  end

  def edit
    @review = @book.reviews.find(params[:id])
    respond_to do |format|
      flash.now[:notice] = 'コメントの編集中'
      format.js { render :edit }
    end
  end

  def update
    @review = @book.reviews.find(params[:id])
      respond_to do |format|
        if @review.update(review_params)
          flash.now[:notice] = 'コメントが編集されました'
          format.js { render :index }
        else
          flash.now[:notice] = 'コメントの編集に失敗しました'
          format.js { render :edit_error }
        end
      end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    respond_to do |format|
      flash.now[:notice] = 'コメントが削除されました'
      format.js { render :index }
    end
  end

  private
  def review_params
    params.require(:review).permit(:book_id, :content)
  end

  def set_book
    @book = Book.find(params[:book_id])
  end
end
