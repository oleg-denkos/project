class UsersController < ApplicationController
	respond_to :html, :json
	require 'builder'
	require 'will_paginate'
	require 'will_paginate/active_record'
  helper_method :sort_column, :sort_direction

  
  
  
  def index
    if current_user && current_user.admin
      @users = User.all
    else
      flash[:notice] = t("users.admin_only")
      redirect_back(fallback_location: root_path)
    end
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


  def edit_multiple
    if params[:commit] == t("users.delete")
      User.where(id: params[:user_ids]).destroy_all
    elsif params[:commit] == t("users.lock")
      User.where(id: params[:user_ids]).each do |user_to_lock|
        user_to_lock.lock_access!
      end
    elsif params[:commit] == t("users.unlock")
      User.where(id: params[:user_ids]).each do |user_to_unlock|
        user_to_unlock.unlock_access!
      end
    elsif params[:commit] == t("users.add_admin")
      User.where(id: params[:user_ids]).each do |user_to_admin|
        user_to_admin.admin = true
        user_to_admin.save
      end
    elsif params[:commit] == t("users.degrade")
      User.where(id: params[:user_ids]).each do |user_to_admin|
        user_to_admin.admin = false
        user_to_admin.save
      end
    end
    redirect_to users_path
  end
  
  def theme
    if current_user.theme != "dark"
      @theme = 'light'
      current_user.theme = "dark"
      current_user.theme.save
    else
      @theme = 'dark'
      current_user.theme = "light"
      current_user.theme.save
    end
  end

  def set_theme

    if current_user.theme != "dark"
      @theme = 'dark'
      current_user.theme = "light"
      current_user.theme.save
    else
      @theme = 'light'
      current_user.theme = "dark"
      current_user.theme.save
    end
  end




  private

  def sort_column
    @sorted.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc" 

  end
end

