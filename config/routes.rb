Rails.application.routes.draw do

  root 'home#index'

  devise_for :admins 
  resources :admins do
    collection do
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

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    destroy: 'users/sessions'
  }

  devise_scope :user do
    patch 'update_cash', to: 'users/registrations#update_cash', as: 'update_cash_user'
  end

  get 'dashboard', to: 'dashboard#show', as: 'dashboard'
  
  resources :transactions, only: [:index, :create]
  get '/transactions/sell', to: 'transactions#sell'
  get '/transactions/buy', to: 'transactions#buy'
  get '/get_available_shares', to: 'transactions#get_available_shares'

  get '/portfolio', to: 'portfolio#index'

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
