Rails.application.routes.draw do
	namespace :users do
		get 'omniauth_callbacks/facebook'
		get 'omniauth_callbacks/vkontakte'
		get 'omniauth_callbacks/twitter'
		devise_scope :user do
			get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
			get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
		end
	end
	post 'auth/:provider/callback', to: 'session#create'
	devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}
	scope ":locale", locale: /en|ru|by/ do
		root to: 'pages#home'
		mount ActionCable.server => '/cable'
		devise_for :users, skip: :omniauth_callbacks

		resources :posts do
			resources 'comments'
			post "rates", to: "rates#create"
			collection do
				get :search
			end
		end
		get 'users/current_user_theme'
		post 'comments/like_or_unlike'
		
		resources 'devise'
		resources :users do

			collection do
				post :edit_multiple
			end
		end

	end
	root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end