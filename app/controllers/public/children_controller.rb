class Public::ChildrenController < ApplicationController

  def new
    @child = Child.new
  end

  def create
    @user = current_user
    @child = Child.new(child_params)
    @child.user_id = @user.id
    if @child.save
      redirect_to my_page_user_path(@user), notice: "お子さんを追加しました"
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
      redirect_to my_page_user_path(@user), notice: "お子さんの情報を更新しました"
    else
      render :edit
    end
  end

  private

  def child_params
    params.require(:child).permit(:name, :birthday, :gender)
  end
end
