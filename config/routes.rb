Rails.application.routes.draw do
  root 'static_pages#home'
  get '/full', to: 'static_pages#full'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  
  get '/signup', to: 'users#new'
  resources :users, except: [:index, :new] do
    member do
      get :followers, :following
    end
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :account_activations, only: [:edit]

  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :posts, only: [:create, :destroy]

  resources :relationships, only: [:create, :destroy]
end
