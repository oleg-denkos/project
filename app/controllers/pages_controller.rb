class PagesController < ApplicationController
	
  def home
  	@posts = Post.order(aver_rate: :desc).limit(3)
  	@posts_updated = Post.order(updated_at: :desc).limit(3)
  end
  
end
