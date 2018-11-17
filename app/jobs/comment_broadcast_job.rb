class CommentBroadcastJob < ApplicationJob
  queue_as :default

  def perform(comment)
    # Do something later
    CommentsChannel.broadcast_to(comment.post, render_comment(comment))
  end

  private
  def render_comment(comment)
  	CommentsController.render(partial: 'comments/comment',locals: {comment: comment})
  end
end
