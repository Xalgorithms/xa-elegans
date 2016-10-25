Rails.application.routes.draw do
  root to: redirect("/transactions")

  devise_for :users
  
  authenticate :user do
    resources :invoices, only: [:show] do
      resources :changes, only: [:index]
    end
    resources :transactions, only: [:index, :show]
    resources :transformations, only: [:index]
  end

  # API
  namespace :api do
    namespace :v1 do
      # new routes
      resources :events, only: [:show, :create]
      resources :documents, only: [:create, :show]

      resources :users, only: [:show], constraints: { id: /[^\/]+/ } do
        resources :transactions, only: [:index]
        resources :invoices, only: [:index]
      end

      resources :transactions, only: [:show] do
        resources :invoices, only: [:index]
      end

      resources :transformations, only: [:show, :index]
      resources :rules, only: [:index]

      resources :invoices, only: [:show] do
        get 'latest', to: 'invoices#latest'
        resource :change, only: [:show]
      end
    end
  end
end
