class FavoritesController < ApplicationController
  def create
    favorite = current_user.favorites.create(summary_id: params[:summary_id])
    redirect_to summaries_url, notice: "#{favorite.summary.user.name}さんの要約をお気に入り登録しました"
  end
  def destroy
    favorite = current_user.favorites.find_by(id: params[:id]).destroy
    redirect_to summaries_url, notice: "#{favorite.summary.user.name}さんの要約をお気に入り解除しました"
  end
end
