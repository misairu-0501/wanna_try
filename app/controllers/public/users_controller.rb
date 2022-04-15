class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:my_page, :edit, :update, :my_favorite]
  before_action :ensure_guest_user, only: [:edit]

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
    if params[:user_name]
      @users = User.where("name LIKE?","%#{params[:user_name]}%")
    elsif params[:post_count]
      @users = User.post_count
    elsif params[:follower_count]
      @users = User.follower_count
    else
      @users = User.all
    end
  end

  def show
    @user = User.find(params[:id])
    #カレントユーザーの場合は自分の全ての投稿を閲覧可能
    if @user == current_user
      if params[:public_status]
        @posts = @user.posts.where(public_status: Post.public_statuses[params[:public_status]]).page(params[:page])
      else
        @posts = @user.posts.page(params[:page])
      end
    #他のユーザーの投稿はpublic_statusesが「全て」の場合のみ閲覧可能
    else
      @posts = @user.posts.where(public_status: Post.public_statuses[:range_all]).page(params[:page])
    end
  end

  def my_favorite
    @user = User.find(params[:id])
    @posts = []
    @user.favorite_posts.each do |favorite_post|
      if (favorite_post.public_status == 0) || (favorite_post.public_status == 1 && same_group?(@user.id, favorite_post.user_id))
        @posts << favorite_post
      end
    end
    @posts = Kaminari.paginate_array(@posts).page(params[:page])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "退会しました"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      flash[:alert] = "他のユーザーの操作はできません"
      redirect_to my_page_user_path(current_user)
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end
end
