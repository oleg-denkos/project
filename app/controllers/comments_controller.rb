class CommentsController < ApplicationController
  before_action :set_post
  before_action :authenticate_user!


  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
    @user = current_user
  end

  def like_or_unlike
    current_user.toggle_like!(@post.comments.find(params[:comment]))
    @comment_id = params[:comment]
    @likes_counter = @post.comments.find(params[:comment]).likers_count
    @user_liked = @post.comments.find(params[:comment]).liked_by?(current_user)
    respond_to do |format|
      format.js {
        render :template => 'comments/like_or_unlike.js.erb'
      }
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body, :post_id)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

end
