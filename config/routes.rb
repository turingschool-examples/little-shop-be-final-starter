Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      namespace :items do
        resources :find, only: :index, controller: :search, action: :show
        resources :find_all, only: :index, controller: :search
      end
      resources :items, except: [:new, :edit] do
        get "/merchant", to: "items/merchants#show"
      end
      namespace :merchants do
        resources :find, only: :index, controller: :search, action: :show
        resources :find_all, only: :index, controller: :search
      end
      resources :merchants, except: [:new, :edit] do
        resources :items, only: :index, controller: "merchants/items"
        resources :customers, only: :index, controller: "merchants/customers"
        resources :invoices, only: :index, controller: "merchants/invoices"
      end
    end
  end

  get "/api/v1/coupons/:id", to: "api/v1/coupons#show"
end
