class UsersController < ApplicationController
	respond_to :html, :json
	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
		@posts = Post.where(user_id: @user.id)
	end
	def update
		@user = User.find(params[:id])
		params.permit!
		@user.update_attributes(params[:user])
		respond_with @user
	end
	def admin
		@user = User.find(params[:id])
		params.permit!
		@user.update_attributes(admin: true)
		@user.save
	end
	
end
