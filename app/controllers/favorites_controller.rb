class FavoritesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  def create
    favorite = current_user.favorites.create(summary_id: params[:summary_id])
    summary = Summary.find(params[:summary_id])
    summary.create_notification_like!(current_user)
    redirect_to summary_path(params[:summary_id])
  end
  def destroy
    favorite = current_user.favorites.find_by(id: params[:id]).destroy
    redirect_to summary_path(favorite.summary.id)
  end
end
