Rails.application.routes.draw do
  resources :stocks
  devise_for :users
  root 'home#index'
  get 'home/about'

  post "/" => 'home#index'

  post 'thinkific/create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
