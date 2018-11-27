class SearchController < ApplicationController
  def index
    @search = Post.search do
      fulltext params[:q]
    end if params[:q]
  end	
end