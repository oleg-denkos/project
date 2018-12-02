Rails.application.routes.draw do
	scope ":locale", locale: /en|ru|by/ do
		root to: 'pages#home'
		mount ActionCable.server => '/cable'
		resources :posts do
			resources 'comments'
			post "rates", to: "rates#create"
			collection do
				get :search
			end
		end

		

		post 'comments/like_or_unlike'
		devise_for :users
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