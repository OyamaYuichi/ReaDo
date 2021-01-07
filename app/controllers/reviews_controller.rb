class ReviewsController < ApplicationController
  before_action :set_book, only: [:create, :edit, :update]
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])
    @review = @book.reviews.build(review_params)
    @review.user_id = current_user.id
    respond_to do |format|
      if @review.save
        read_level = Review.calc_level(current_user)
        current_user.update(level: read_level.floor)
        format.js { render :index }
      else
        format.html { redirect_to book_path(@book) }
      end
    end
  end

  def edit
    @review = @book.reviews.find(params[:id])
    respond_to do |format|
      format.js { render :edit }
    end
  end

  def update
    @review = @book.reviews.find(params[:id])
      respond_to do |format|
        if @review.update(review_params)
          format.js { render :index }
        else
          format.js { render :edit_error }
        end
      end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    read_level = Review.calc_level(current_user)
    current_user.update(level: read_level.floor)
    respond_to do |format|
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
