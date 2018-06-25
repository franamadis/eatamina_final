Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'dashboard/requests'
  get 'additive/show'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :products, only: [:index, :new, :create, :show, :edit, :update]

  resources :additives, only: [:show]

  resources :products do
    member do
      put "like", to: "products#upvote"
      put "dislike", to: "products#downvote"
    end
  end

end
