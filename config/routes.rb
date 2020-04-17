Rails.application.routes.draw do
  root 'homepages#home'

  resources :discoveries
end
