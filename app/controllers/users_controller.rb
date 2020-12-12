class UsersController < ApplicationController
  def index
    @users = User.all
    # @users = User.all.includes(:active_relationships, :passive_relationships, :following, :followers)
  end

  def show
    @user = User.find(params[:id])
    calc_level = @user.summaries.count * 0.6 + @user.memos.count * 0.2
    @level = calc_level.floor
  end

  def following
    @user = User.find_by(id: params[:id])
    @users = @user.following
  end

  def follower
    @user = User.find_by(id: params[:id])
    @users = @user.followers
  end
end
