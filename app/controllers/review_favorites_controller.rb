class ReviewFavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @review = Review.find(params[:review_id])
    like = current_user.review_favorites.build(review_id: params[:review_id])
    like.save
  end

  def destroy
    @review = Review.find(params[:id])
    like = ReviewFavorite.find_by(review_id: @review, user_id: current_user.id)
    like.destroy
  end
end
