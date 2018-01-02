# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # Static Stuff
  root 'static_pages#home'
  match '/home' => "static_pages#home", via: [:get]
  match '/terms' => "static_pages#terms", via: [:get]
  match '/instagram' => "static_pages#instagram", via: [:get]
  match '/join' => "static_pages#join", via: [:get]
  match '/blog' => "articles#list", via: [:get], as: 'blog'
  post '/contact', to: 'static_pages#contact', as: 'contact'

  # The User-facing App
  resource :dashboard, controller: 'dashboard' do
  end

  resources :participants do
    get :list, on: :collection
  end

  resources :submissions do
    get :list, on: :collection
  end

  resources :questions do
    get :list, on: :collection
    post :update_row_order, on: :collection
  end

  resources :studio_session_types do
    get :list, on: :collection
    post :update_row_order, on: :collection
  end

  resources :pricing_options do
    get :list, on: :collection
    post :update_row_order, on: :collection
  end

  resources :studio_sessions do
    get :list, on: :collection
    post :update_row_order, on: :collection
  end

  resources :coaches do
    get :list, on: :collection
    post :update_row_order, on: :collection
  end

  resources :events do
    get :list, on: :collection
    post :update_row_order, on: :collection
    resources :registrations
  end

  resources :challenges do
    get :list, on: :collection
  end

  resources :articles do
    get :list, on: :collection
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    invitations: 'users/invitations',
    passwords: 'users/passwords',
  }

  namespace :twilio do
    resources :submissions, only: [:create]
  end

  # Admin Space
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
