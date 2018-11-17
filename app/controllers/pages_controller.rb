class PagesController < ApplicationController
  def home
  	@posts = Post.order(id: :desc).limit(3)
  end
end
