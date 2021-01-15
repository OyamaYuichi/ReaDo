class CommentFavoritesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @comment = Comment.find(params[:comment_id])
    like = current_user.comment_favorites.build(comment_id: params[:comment_id])
    like.save
  end

  def destroy
    @comment = Comment.find(params[:id])
    like = CommentFavorite.find_by(comment_id: @comment, user_id: current_user.id)
    like.destroy
  end
end
