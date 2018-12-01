class SearchController < ApplicationController
	def index
		@search = Post.search do
			fulltext params[:q]	 do
				boost_fields :tag_list => 5.0
			end
		end if params[:q]
	end	
end