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
  @user = User.from_omniauth_vk(request.env["omniauth.auth"])
  if @user.persisted?
    sign_in_and_redirect @user, :event => :authentication
    set_flash_message(:notice, :success, :kind => "Vkontakte") if is_navigational_format?
  else
    session["devise.vkontakte_data"] = request.env['omniauth.auth']
    redirect_to new_user_registration_url
  end
end


  def twitter
  end
end
