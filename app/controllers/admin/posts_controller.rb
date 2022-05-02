class Admin::PostsController < ApplicationController
  def index
    if params[:positive]
      @posts = Post.positive.page(params[:page]).per(10)
    elsif params[:negative]
      @posts = Post.negative.page(params[:page]).per(10)
    else
      @posts = Post.page(params[:page]).per(10)
    end
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
