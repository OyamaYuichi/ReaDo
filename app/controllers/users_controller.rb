class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :following, :follower]
  def index
    @users = User.all.order(level: :desc).limit(10)
  end

  def show
    @user = User.find(params[:id])
    @read_count = @user.summaries.group_by_day(:created_at, range: 2.weeks.ago.midnight..Time.now).size
    @summaries = @user.summaries.order(created_at: :desc).page(params[:page]).per(20)
    @memos = @user.memos.order(created_at: :desc).page(params[:page]).per(20)
    @favorites = @user.favorite_summaries.order(created_at: :desc).page(params[:page]).per(20)
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
