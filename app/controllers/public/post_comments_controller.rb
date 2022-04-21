class Public::PostCommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    comment = PostComment.new(post_comment_params)
    comment.user_id = current_user.id
    comment.post_id = @post.id
    comment.save
    #非同期通信(@postをjsファイルに渡す)
    # redirect_to request.referer
  end

  def destroy
    @post = Post.find(params[:post_id])
    PostComment.find(params[:id]).destroy
    #非同期通信(@postをjsファイルに渡す)
    # redirect_to request.referer
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
