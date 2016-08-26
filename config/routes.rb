Rails.application.routes.draw do
  devise_for :users

  resources :books do
  	resources :comments, controller: 'book_comments'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "books#index"
end
