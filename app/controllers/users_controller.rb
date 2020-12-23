class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :following, :follower]
  def index
    @users = User.all.order(level: :desc).limit(10)
  end

  def show
    @user = User.find(params[:id])
    calc_level
    @level = @read_level.floor
    @summaries = @user.summaries.order(created_at: :desc).page(params[:page]).per(20)
    @memos = @user.memos.order(created_at: :desc).page(params[:page]).per(20)
    @favorites = @user.favorite_summaries.order(created_at: :desc).page(params[:page]).per(20)
  end

  def calc_level
    @read_level = @user.summaries.count * 0.6
                  + @user.memos.count * 0.2
                  + @user.reviews.count * 0.1
                  + @user.comments.count * 0.1
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
