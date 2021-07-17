Rails.application.routes.draw do
  devise_for :users, controllers: { :omniauth_callbacks => "omniauth_callbacks" }
  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :show, :create] do
    resources :comments, only: [:create]
  end

  
  root 'posts#index'

  get 'pages/show'
  get 'pages/eech'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end