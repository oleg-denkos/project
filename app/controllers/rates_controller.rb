class RatesController < ApplicationController
	before_action :find_post

	def new
		@rate = Rate.new
	end

	def create
		@rate = Rate.new(rate_params)
		@rate.post_id = @post.id
		@rate.user_id = current_user.id
		@rate.voters_count = 1
		if @rate.save
			redirect_to post_path(@post )
		else
			render 'new'
		end
	end


	private

	def rate_params
		params.require(:rate).permit(:rating)
	end

	def find_post
		@post = Post.find(params[:post_id])
	end

end