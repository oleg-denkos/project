class Users::OmniauthCallbacksController < ApplicationController

  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      flash[:notice] = 'Logged via Facebook'
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end

  def vkontakte
    @user = User.find_for_vkontakte_oauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      flash[:notice] = 'Logged via vkontakte'
    else
      session["devise.vkontakte_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end


  def twitter
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      flash[:notice] = 'Logged via Twitter'
    else
      session["devise.Twitter_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
