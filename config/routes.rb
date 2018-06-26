Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get "products/message", to: "products#message"
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :additives, only: [:show]

  resources :products do
    member do
      put "like", to: "products#upvote"
      put "dislike", to: "products#downvote"
    end
  end

  get "queries", to: "queries#index"
  get 'howitworks', to: "pages#howwork"

end
