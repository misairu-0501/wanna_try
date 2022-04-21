class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    if params[:user_name]
      @users = User.where("name LIKE?","%#{params[:user_name]}%").page(params[:page]).per(10)
    else
      @users = User.page(params[:page]).per(10)
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "会員情報を更新しました"
      redirect_to admin_user_path(@user)
    else
      render "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "#{@user.name}さんを退会させました"
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :is_deleted)
  end

end
