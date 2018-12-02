class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :body, presence: true, allow_blank: false


  acts_as_likeable

  
  update_index('posts#post') { post }


  after_create_commit {
  	CommentBroadcastJob.perform_later(self)
  }

end
