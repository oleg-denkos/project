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
 
 def do_reset_password
  id = params[:id]

  if params[:user][:password] != params[:user][:password_confirmation]
    flash[:alert] = "Passwords must match." 
    redirect_to :back
    return
  end
  if @user.reset_password!(params[:user][:password],params[:user][:password_confirmation])
    @user.save
    respond_to do |format|
      format.html { redirect_to @user, notice: 'Your password has been changed.' }
    end
  else
    flash[:alert] = "Invalid password, must be at least 6 charactors." 
    redirect_to :back 
  end
end

def edit_multiple
    if params[:commit] == "Delete"
      User.where(id: params[:user_ids]).destroy_all
    elsif params[:commit] == "Lock"
      User.where(id: params[:user_ids]).each do |user_to_lock|
        user_to_lock.lock_access!
      end
    elsif params[:commit] == "Unlock"
      User.where(id: params[:user_ids]).each do |user_to_unlock|
        user_to_unlock.unlock_access!
      end
    elsif params[:commit] == "Add admin"
      User.where(id: params[:user_ids]).each do |user_to_admin|
        user_to_admin.admin = true
        user_to_admin.save
      end
    end
    redirect_to users_path
  end

private

def sort_column
  @sorted.column_names.include?(params[:sort]) ? params[:sort] : "title"
end

def sort_direction
  %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc" 

end
end

