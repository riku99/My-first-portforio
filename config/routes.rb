Rails.application.routes.draw do
  get 'users/new'
  root 'homepages#home'

  resources :discoveries
end
