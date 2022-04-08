class Public::ChildrenController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only:[:edit, :update]

  def new
    @child = Child.new
  end

  def create
    @user = current_user
    @child = Child.new(child_params)
    @child.user_id = @user.id
    if @child.save
      flash[:notice] = "お子さんを追加しました"
      redirect_to my_page_user_path(@user)
    else
      render :new
    end
  end

  def edit
    @child = Child.find(params[:id])
  end

  def update
    @user = current_user
    @child = Child.find(params[:id])
    if @child.update(child_params)
      flash[:notice] = "お子さんの情報を更新しました"
      redirect_to my_page_user_path(@user)
    else
      render :edit
    end
  end

  private

  def child_params
    params.require(:child).permit(:name, :birthday, :gender)
  end

  def ensure_correct_user
    @child = Child.find(params[:id])
    unless @child.user_id == current_user.id
      flash[:alert] = "他のユーザーのお子さんの編集はできません"
      redirect_to my_page_user_path(current_user)
    end
  end
end
