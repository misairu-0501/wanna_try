class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:my_page, :edit, :update]

  def my_page
    @user = User.find(params[:id])
    @children = @user.children
    @groups = @user.groups
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "ユーザー情報を更新しました。"
      redirect_to my_page_user_path(@user)
    else
      render :edit
    end
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])

    #カレントユーザーの場合は自分の全ての投稿を閲覧可能
    #他のユーザーの投稿はpublic_statusesが「全て」の場合のみ閲覧可能
    if @user == current_user
      @posts = @user.posts
    else
      @posts = @user.posts.where(public_status: Post.public_statuses[:range_all])
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      flash[:alert] = "他のユーザーの編集はできません"
      redirect_to my_page_user_path(current_user)
    end
  end
end
