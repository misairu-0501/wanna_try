class Admin::PostsController < ApplicationController
  def index
    @posts = Post.page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to admin_posts_path
  end
end
