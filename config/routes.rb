Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  namespace :api do
    defaults format: :json do
      post "login", to: "claims#create"
      post "register", to: "users#create"
      resources :users, only: [:index, :show, :create, :update, :destroy]
    end
  end

  match '*path', to: 'application#render_404', via: :all, code: 404
end
