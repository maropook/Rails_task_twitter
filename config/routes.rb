Rails.application.routes.draw do
  devise_for :users, controllers: { :omniauth_callbacks => "omniauth_callbacks" }
  get 'users/myself' => 'users/myself'
  get 'users/history' => 'users/history'
  resources :users, only: [:index, :show] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  root 'pages#farmily'
  get 'pages/show'
  get 'pages/eech'
  get 'pages/farmily'
  get 'pages/howtofarmily'
  resources :messages, :only => [:create]
  resources :rooms, :only => [:create, :show, :index]
  get 'search' => 'posts#search'
  get 'searchfollow' => 'posts#searchfollow'
  get 'posts/global' => 'posts#global'
  get 'posts/random' => 'posts#random'
  get 'posts/follow' => 'posts#follow'
  get 'posts/record' => 'posts#record'
  get 'posts/other' => 'posts#other'
  resources :posts, only: [:index, :show, :create, :destroy, :edit, :update] do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
