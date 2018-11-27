Rails.application.routes.draw do
	root to: 'pages#home'
	mount ActionCable.server => '/cable'
	resources :posts do
		resources 'comments' do
			member do
				get 'like'
				get 'unlike'
			end
		end
	end

	
	get "search", to: 'search#index'
	post 'comments/like_or_unlike'
	devise_for :users
	resources :users
	post 'users', to: 'users#admin'



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end