Rails.application.routes.draw do

  root 'home#index'

  devise_for :admins
  resources :admins do
    member do
      get 'new_user'
      post 'create_user'
      get 'edit_user'
      patch 'update_user'
      get 'show_user'
      post 'approve_user'
    end

    collection do
      get 'pending_trader_signups'
      get 'all_transactions'
    end
  end

  devise_for :users
  get 'dashboard', to: 'dashboard#show'
  resources 'trade', only: [:index]
  resources :transactions, only: [:index]
  
  get "trade", to: "trade#index"

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
