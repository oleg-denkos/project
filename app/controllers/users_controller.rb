class UsersController < ApplicationController
	respond_to :html, :json
	require 'builder'
	require 'will_paginate'
	require 'will_paginate/active_record'

	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])

		@user.posts.paginate(:page => params[:page], :per_page => 10)	

		@filterrific = initialize_filterrific(
			@user.posts,
			params[:filterrific],
			select_options: {
				sorted_by: @user.posts.options_for_sorted_by },
				persistence_id: 'shared_key',
				default_filter_params: {},
				available_filters: [:sorted_by, :with_title, :with_spec, :with_created_at],
				sanitize_params: false
				) or return
		@posts = @filterrific.find.page(params[:page])
    # Respond to html for initial page load and to js for AJAX filter updates.
    respond_to do |format|
    	format.html
    	format.js
    end

  rescue ActiveRecord::RecordNotFound => e
  	puts "Had to reset filterrific params: #{ e.message }"
  	redirect_to(reset_filterrific_url(format: :html)) and return
  end

  def reset_filterrific
  	session[:filterrific_restaurants] = nil
  	redirect_to action: :show
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
