Rails.application.routes.draw do
  root to: redirect("/transactions")

  devise_for :users
  
  authenticate :user do
    resources :invoices, only: [:show]
    resources :transactions, only: [:index, :show]
  end

  # API
  namespace :api do
    namespace :v1 do
      # new routes
      resources :users, only: [] do
        resources :transactions, only: [:index, :create, :destroy] do
          resources :invoices, only: [:create]
        end
      end

      resources :transactions, only: [] do
        resources :invoices, only: [:index]
        resources :rules, only: [:create]
      end
    end
  end
end
