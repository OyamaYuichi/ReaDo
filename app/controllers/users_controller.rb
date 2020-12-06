class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
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
