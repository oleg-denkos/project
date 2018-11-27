class UsersController < ApplicationController
	respond_to :html, :json
	require 'builder'
	require 'will_paginate'
	require 'will_paginate/active_record'
  helper_method :sort_column, :sort_direction

  
  
	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
    params[:sort] ||= "created_at"
    params[:direction] ||= "desc"
		@sorted = @user.posts.order(params[:sort] + " " + params[:direction])

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

 private

 def sort_column
  @sorted.column_names.include?(params[:sort]) ? params[:sort] : "title"
end

def sort_direction
  %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc" 

end
end

