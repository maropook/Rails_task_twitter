Rails.application.routes.draw do
  devise_for :users, controllers: { :omniauth_callbacks => "omniauth_callbacks" }
  resources :users, only: [:index, :show] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end  
  root 'pages#farmily'

  resources :messages, :only => [:create]
  resources :rooms, :only => [:create, :show, :index]

  resources :posts, only: [:index, :show, :create, :destroy, :edit, :update] do
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
  end


  get 'pages/show'
  get 'pages/eech'
  get 'pages/farmily'
  get 'pages/howtofarmily'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end