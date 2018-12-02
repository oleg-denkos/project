class ApplicationController < ActionController::Base
	protect_from_forgery
	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :set_locale, :theme

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def theme
    if cookies[:theme]
      @theme = cookies[:theme]
    else
      @theme = "light"
    end
  end

  private

  def set_locale 
    if params[:locale] 
      I18n.locale = params[:locale] 
    elsif cookies[:locale] 
      I18n.locale = cookies[:locale] 
    else I18n.locale = I18n.default_locale
    end 
    cookies[:locale] = I18n.locale 
  end



  def default_url_options
    {locale: I18n.locale}    
  end
end
