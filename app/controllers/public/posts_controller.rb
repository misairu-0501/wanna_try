class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only:[:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @user = current_user
    @post = Post.new(post_params)
    @post.user_id = @user.id
    if @post.save
      flash[:notice] = "投稿を作成しました"
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @user = current_user
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "投稿を更新しました"
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def index
    @genres = Genre.all

    if params[:id]
      @genre = Genre.find(params[:id])
      @posts = @genre.posts.where(public_status: Post.public_statuses[:range_all])
    else
      #公開範囲が「全体」のもののみを表示する。
      @posts = Post.all.where(public_status: Post.public_statuses[:range_all])
    end
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to user_path(current_user)
  end

  private

  def post_params
    params.require(:post).permit(:child_id, :genre_id, :title, :body, :shooting_date, :public_status, :post_image)
  end

  def ensure_correct_user
    @post = Post.find(params[:id])
    unless @post.user_id == current_user.id
      flash[:alert] = "他のユーザーの投稿の編集はできません"
      redirect_to my_page_user_path(current_user)
    end
  end
end
