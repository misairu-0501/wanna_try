class Admin::PostCommentsController < ApplicationController
  def index
    @post_comments = PostComment.page(params[:page]).per(10)
  end

  def destroy
    @post = Post.find(params[:post_id])
    PostComment.find(params[:id]).destroy
    #非同期通信(@postをjsファイルに渡す)
    # redirect_to request.referer
  end
end
