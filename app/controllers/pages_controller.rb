class PagesController < ApplicationController
  def home
  	@posts = Post.order(updated_at: :desc).limit(3)
  end
end
