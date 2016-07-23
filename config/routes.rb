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
      resources :documents, only: [:create]
      
      resources :users, only: [] do
        resources :transactions, only: [:index]
      end

      resources :transactions, only: [] do
        resources :invoices, only: [:index]
      end

      resources :transformations, only: [:show]
      resources :rules, only: [:index]
    end
  end
end
