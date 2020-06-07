Rails.application.routes.draw do
  root 'homepages#home'
  resources :users do
    member do
      get :following, :followers, :change_to_comment, :change_to_discovery, :feed, :favorite   #users/:id/following, users/:id/followersを使えるようになる
    end
  end
  resources :discoveries
  resources :relationships, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]
  resources :comments, only: [:new, :create, :destroy, :show]
  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  delete '/logout', to: "sessions#destroy"
  delete '/imgd/:id', to: "users#imgd", as: "imgd"
  get '/api/users/current_user', to: "api/users#current_user"
end
