class Public::UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:my_page, :edit, :update]

  def my_page
    @user = User.find(params[:id])
    @children = @user.children
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
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      flash[:alert] = "他のユーザーの編集はできません"
      redirect_to my_page_user_path(current_user)
    end
  end
end
