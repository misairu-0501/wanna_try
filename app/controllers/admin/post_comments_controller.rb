class Admin::PostCommentsController < ApplicationController
  def index
    if params[:positive]
      @post_comments = PostComment.positive.page(params[:page]).per(10)
    elsif params[:negative]
      @post_comments = PostComment.negative.page(params[:page]).per(10)
    else
      @post_comments = PostComment.page(params[:page]).per(10)
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    PostComment.find(params[:id]).destroy
    #非同期通信(@postをjsファイルに渡す)
    # redirect_to request.referer
  end
end
