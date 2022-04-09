class Public::RelationshipsController < ApplicationController

  #フォローするときの処理
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end

  #フォローを外すときの処理
  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  #フォロー一覧を取得
  def followings
    user = User.find(params[:user_id])
    @user = user.followings
  end

  #フォロワー一覧を取得
  def followers
    user = User.find(params[:user_id])
    @user = user.followers
  end
end