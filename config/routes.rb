Rails.application.routes.draw do
  root 'homepages#home'
  resources :users do
    member do
      get :following, :followers, :othre_following    #users/:id/following, users/:id/followersを使えるようになる
    end
  end
  resources :discoveries
  resources :relationships, only: [:create, :destroy]
  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  delete '/logout', to: "sessions#destroy"
  delete '/imgd/:id', to: "users#imgd", as: "imgd"
end
