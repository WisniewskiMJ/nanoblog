Rails.application.routes.draw do
  root 'static_pages#home'
  get '/all_posts', to: 'static_pages#all_posts'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  
  get '/signup', to: 'users#new'
  resources :users, except: [:index, :new] do
    member do
      get :followers, :following
      get :inactive
      get :resend_activation
    end
  end

  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'


  resources :account_activations, only: [:new, :edit]

  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :posts, only: [:create, :destroy]

  resources :relationships, only: [:create, :destroy]
end
