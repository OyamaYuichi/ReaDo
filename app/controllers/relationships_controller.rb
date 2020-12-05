class RelationshipsController < ApplicationController
  # Deviseを使用しているならif logged_in?の代わりに下記を使用する。
  before_action :authenticate_user!
  respond_to? :js # 存在するアクションのrespondを全てjsで返す場合はこのような記述でも可能。
  def create
    # 自身で作ったログイン機能であれば、独自実装してあるはずの
    # logged_in?メソッドを使用して、ログイン時のみフォローできるようにする。
      @user = User.find(params[:relationship][:followed_id])
      current_user.follow!(@user)
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
  end
end
