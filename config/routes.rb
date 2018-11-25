Rails.application.routes.draw do
	root to: 'pages#home'
	mount ActionCable.server => '/cable'
	resources :posts do
		post 'comments', to: 'comments#create'
		post 'like_or_unlike'
	end

	devise_for :users
	resources :users
	post 'users', to: 'users#admin'
	post 'comments/like_or_unlike'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end