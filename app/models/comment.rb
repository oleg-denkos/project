class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :body, presence: true, allow_blank: false

  after_create_commit {
  	CommentBroadcastJob.perform_later(self)
  }

end
