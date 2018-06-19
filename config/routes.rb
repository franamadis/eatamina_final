Rails.application.routes.draw do
  get 'dashboard/requests'
  get 'additive/show'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :products, only: [:new, :create, :show, :edit, :update]

  resources :additives, only: [:show]


end
