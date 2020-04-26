Rails.application.routes.draw do
  root 'homepages#home'

  resources :discoveries
  resources :users
end
