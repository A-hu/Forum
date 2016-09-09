Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :books do
  	resources :comments, controller: 'book_comments'
	
  	collection do
  	  get :about
  	  post :bulk_selectgroup
  	end

    member do
      post :collection
      post :like
      post :subscribe
    end
  end



  resources :users 

  namespace :admin do
    resources :books
    resources :groups
    resources :users
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "books#index"
end
